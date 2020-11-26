import std/strutils
import ./core

type Password = string

func has3LettersIncrease(password: Password): bool =
  for triples in password.partial(3):
    if triples.hasStraightIncrease:
      return true

func hasBadLetters(password: Password): bool =
  {'i', 'o', 'l'} in password

func hasNonOverlappingPairs(password: Password): bool =
  var paired: set[char] = {}
  for pair in password.partial(2):
    if pair[0] == pair[1]:
      paired.incl(pair[0])
  paired.card >= 2

func isValid(p: Password): bool =
  not p.hasBadLetters and p.has3LettersIncrease and p.hasNonOverlappingPairs

func `++`(s: var Password) =
  for i in countdown(s.high, 0):
    if s[i] < 'z':
      s[i] = succ(s[i])
      return
    s[i] = 'a'

func nextValid(password: var Password): Password =
  doWhile not password.isValid:
    ++password
  password

when isMainModule:
  var password = stdin.readLine

  when IsPart2:
    discard password.nextValid

  echo "Part ", Part, ": ", password.nextValid

  static:
    assert "hijklmmn".has3LettersIncrease
    assert "hijklmmn".hasBadLetters
    assert "abbceffg".hasNonOverlappingPairs
    assert not "abbceffg".has3LettersIncrease
    assert not "abbcegjk".hasNonOverlappingPairs
