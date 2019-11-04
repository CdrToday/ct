import 'dart:math';

String rngName () {
  List<String> adj = [
    '沉默的',
    '善良的',
    '欢脱的',
    '冷酷的',
    '调皮的',
    '坚定的',
    '年迈的',
    '脾气超大的'
  ];

  List<String> noun = [
    '麋鹿',
    '饼干',
    '二弦琴',
    '久保',
    '龅牙哥',
    '泡儿'
  ];

  return adj[Random().nextInt(adj.length)] + noun[Random().nextInt(noun.length)];

  // List<String> _nl = [
  //   'David Bowie',
  //   'Iggy Pop',
  //   'Lou Reed',
  //   'Kurt Cobain',
  //   'Bob Dylan',
  //   'John Lennon',
  //   'Patti Smith',
  //   'Joan Baez',
  //   'Donovan',
  //   'Chunk Berry',
  //   'Elvis Presley',
  //   'Leonard Cohen',
  //   'Rodriguez',
  //   'Neil Young',
  //   'Jim Morison',
  //   'Eric Clapton',
  // ];
  // return _nl[Random().nextInt(15)];
}
