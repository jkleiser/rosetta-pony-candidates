use "random"

actor Main
  let _env: Env
  let _rand: MT = MT	// Mersenne Twister
  let _target: Array[U8] val = "METHINKS IT IS LIKE A WEASEL".array()
  let _possibilities: Array[U8] val = "ABCDEFGHIJKLMNOPQRSTUVWXYZ ".array()
  let _c: U16 = 100	// number of spawn per generation
  let _minMutateRate: F64 = 0.09
  let _perfectFitness: USize = _target.size()
  var _parent: Array[U8] = Array[U8]
  
  new create(env: Env) =>
    _env = env
    _parent = mutate(_target, 1.0)
    var iter: U64 = 0
    while fitness(_parent) < _parent.size() do	// using fitness here is not optimal
      let rate: F64 = newMutateRate()
      iter = iter + 1
      if (iter % 100) == 0 then
        _env.out.write(iter.string() + ": ")
        _env.out.write(arrayVal(_parent))
        _env.out.write(", fitness: " + fitness(_parent).string())
        _env.out.print(", rate: " + rate.string())
      end
      var bestSpawn: Array[U8] = Array[U8]
      var bestFit: USize = 0
      var i: U16 = 0
      while i < _c do
        let spawn = mutate(arrayVal(_parent), rate)
        let spawn_fitness = fitness(spawn)
        if spawn_fitness > bestFit then
          bestSpawn = spawn
          bestFit = spawn_fitness
        end
        i = i + 1
      end
      if bestFit > fitness(_parent) then
        _parent = bestSpawn
      end
    end
    _env.out.write(arrayVal(_parent))
    _env.out.print(", " + iter.string())

  fun arrayVal(inArr: Array[U8]): Array[U8] val =>
    let outArr = recover Array[U8] end
    for c in inArr.values() do
      outArr.push(c)
    end
    outArr

  fun fitness(trial: Array[U8] box): USize =>
    var retVal: USize = 0
    var i: USize = 0
    while i < trial.size() do
      try
        if trial(i) == _target(i) then
          retVal = retVal + 1
        end
      end
      i = i + 1
    end
    retVal

  fun newMutateRate(): F64 =>
    let perfectFit = _perfectFitness.f64()
    ((perfectFit - fitness(_parent).f64()) / perfectFit) * (1.0 - _minMutateRate)

  fun ref mutate(parent: Array[U8] val, rate: F64): Array[U8] =>
    var retVal = Array[U8]
    for char in parent.values() do
      let rndReal: F64 = _rand.real()
      if rndReal <= rate then
        let rndInt: U64 = _rand.int(_possibilities.size().u64())
        try
          retVal.push(_possibilities(rndInt.usize()))
        end
      else
        retVal.push(char)
      end
    end
    retVal
