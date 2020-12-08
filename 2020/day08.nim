import std/[sets, math, hashes, sequtils]
when IsPart2:
  import std/sugar


type
  OperationKind = enum
    okAcc, okJmp, okNop

  Instruction = ref object
    line: int
    kind: OperationKind
    argument: int

  BootCode = ref object
    instrs: seq[Instruction]
    executed: HashSet[Instruction]
    line: int
    accumlator: int


proc hash(self: Instruction): Hash =
  !$(self.kind.hash !& self.argument.hash !& self.line.hash)


# proc `$`(self: Instruction): string =
#   &"{self.kind} {self.argument}"


proc currentInstruction(self: BootCode): Instruction =
  self.instrs[self.line]


proc hasTerminated(self: BootCode): bool =
  self.line == self.instrs.high


proc hasLooped(self: BootCode): bool =
  self.currentInstruction in self.executed


proc isDone(self: BootCode): bool =
  self.hasTerminated or self.hasLooped


# proc `$`(self: BootCode): string =
#   result &= &"done        : {self.isDone}\n"
#   result &= &"instructions: {self.instrs.len}\n"
#   result &= &"executed    : {self.executed.len}\n"
#   result &= &"accumlator  : {self.accumlator}\n"

#   const PAD = 8
#   let min = (self.line - PAD).max(0)
#   let max = (self.line + PAD).min(self.instrs.high)

#   for instr in self.instrs[min .. max]:
#     result &= fmt("{instr.line} ").align(3)
#     if instr.line == self.line:
#       result &= fmt("-> {instr.kind} {instr.argument}")
#     else:
#       result &= fmt("{instr.kind} {instr.argument}").indent(3)
#     result &= "\n"


proc step(self: var BootCode) =
  assert not self.isDone and not self.hasTerminated
  let current = self.currentInstruction
  assert current notin self.executed
  self.executed.incl(current)
  case current.kind:
  of okAcc:
    self.accumlator += current.argument
    self.line += 1
  of okJmp:
    self.line = floorMod(self.line + current.argument, self.instrs.len)
  of okNop:
    self.line += 1


proc detectCycle(self: var BootCode) =
  while not self.isDone:
    self.step


proc parse(input: string): BootCode =
  result = new BootCode
  for i, line in toSeq(input.splitLines).pairs:
    let split = line.split" "
    let operator = case split[0]:
      of "acc": okAcc
      of "jmp": okJmp
      of "nop": okNop
      else: quit &"unknown operator `{split[0]}`"
    let argument = split[1].parseInt
    result.instrs.add Instruction(kind: operator, argument: argument, line: i)


proc solve(input: string): int =
  var vm = input.parse

  when IsPart1:
    vm.detectCycle()
    vm.accumlator
  else:
    let candidates = vm.instrs.filter(ins => ins.kind in [okJmp, okNop])
    for op in candidates:
      let tmp = op.kind
      op.kind = if op.kind == okNop: okJmp else: okNop

      vm.detectCycle()
      if vm.hasTerminated:
        return vm.accumlator

      op.kind = tmp
      vm.line = 0
      vm.accumlator = 0
      vm.executed.clear()


when isMainModule:
  echo OutputPrefix, stdin.readAll.strip.solve
