import std/[tables, sequtils]
when IsPart2: import std/[sugar, parseutils]

type
  FieldKind = enum
    fkByr, fkIyr, fkEyr, fkHgt, fkHcl, fkEcl, fkPid, fkCid
  Passport = Table[FieldKind, string]

const FieldAmount = FieldKind.high.ord + 1

when IsPart2:
  proc isValid(fk: FieldKind; value: string): bool =
    case fk:
    of fkByr: value >= "1920" and "2002" >= value
    of fkIyr: value >= "2010" and "2020" >= value
    of fkEyr: value >= "2020" and "2030" >= value
    of fkHgt:
      var num: int
      var unit: string
      discard parseUntil(value, unit, Whitespace, parseInt(value, num))
      case unit:
      of "cm": num >= 150 and 193 >= num
      of "in": num >= 59 and 76 >= num
      else: false
    of fkHcl: value.len == 7 and value[0] == '#' and value[1 .. ^1].all(x => x in HexDigits)
    of fkEcl: value in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
    of fkPid: value.len == 9 and value.all(x => x in Digits)
    of fkCid: true

proc hasValidFields(p: Passport): bool =
  result = true
  when IsPart2:
    for fk, val in p.pairs:
      if not fk.isValid val: return false

proc isValid(p: Passport): bool =
  let hasAllFields = p.len == FieldAmount
  let hasCIDField = p.hasKey(fkCid)
  let isMissingOneField = p.len == FieldAmount - 1
  (hasAllFields or (not hasCIDField and isMissingOneField)) and p.hasValidFields

proc parse(input: string): seq[Passport] =
  var tmp: Passport
  for line in input.splitLines:
    if line.isEmptyOrWhitespace:
      result.add move(tmp)
    else:
      for pairs in line.splitWhitespace:
        let pair = pairs.split":"
        let fk = case pair[0]:
        of "byr": fkByr
        of "iyr": fkIyr
        of "eyr": fkEyr
        of "hgt": fkHgt
        of "hcl": fkHcl
        of "ecl": fkEcl
        of "pid": fkPid
        of "cid": fkCid
        else: quit &"Unknown required field `{pair[0]}` in input"
        tmp[fk] = pair[1]
  if tmp.len != 0:
    result.add move(tmp)

proc solve(input: string): int =
  input.parse.filter(isValid).len

when isMainModule:
  echo OutputPrefix, stdin.readAll.strip.solve

  static:
    when IsPart1:
      const example = """ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm

iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
hcl:#cfa07d byr:1929

hcl:#ae17e1 iyr:2013
eyr:2024
ecl:brn pid:760753108 byr:1931
hgt:179cm

hcl:#cfa07d eyr:2025 pid:166559648
iyr:2011 ecl:brn hgt:59in"""

      assert example.solve == 2
    else:
      assert fkByr.isValid"2002"
      assert not fkByr.isValid"2003"

      assert fkHgt.isValid"60in"
      assert fkHgt.isValid"190cm"
      assert not fkHgt.isValid"190in"
      assert not fkHgt.isValid"190"

      assert fkHcl.isValid"#123abc"
      assert not fkHcl.isValid"#123abz"
      assert not fkHcl.isValid"123abc"

      assert fkEcl.isValid"brn"
      assert not fkEcl.isValid"wat"

      assert fkPid.isValid"000000001"
      assert not fkPid.isValid"0123456789"

      const invalidPassports = """eyr:1972 cid:100
hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

iyr:2019
hcl:#602927 eyr:1967 hgt:170cm
ecl:grn pid:012533040 byr:1946

hcl:dab227 iyr:2012
ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

hgt:59cm ecl:zzz
eyr:2038 hcl:74454a iyr:2023
pid:3556412378 byr:2007"""
      assert invalidPassports.solve == 0

      const validPassports = """pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
hcl:#623a2f

eyr:2029 ecl:blu cid:129 byr:1989
iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

hcl:#888785
hgt:164cm byr:2001 iyr:2015 cid:88
pid:545766238 ecl:hzl
eyr:2022

iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719"""
      assert validPassports.solve == 4
