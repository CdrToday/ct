import 'dart:math';

String rngName () {
  List<String> _nl = [
    'David Bowie',
    'Iggy Pop',
    'Lou Reed',
    'Kurt Cobain',
    'Bob Dylan',
    'John Lennon',
    'Patti Smith',
    'Joan Baez',
    'Donovan',
    'Chunk Berry',
    'Elvis Presley',
    'Leonard Cohen',
    'Rodriguez',
    'Neil Young',
    'Jim Morison',
    'Eric Clapton',
  ];
  var rng = new Random();
  return _nl[rng.nextInt(15)];
}
