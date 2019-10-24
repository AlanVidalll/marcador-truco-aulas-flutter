import 'package:flutter/material.dart';
import 'package:marcador_truco/models/player.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _playerOne = Player(name: "Nós", score: 0, victories: 0);
  var _playerTwo = Player(name: "Eles", score: 0, victories: 0);
  @override
  void initState() {
    super.initState();
    _resetPlayers();
  }

  void _resetTudo({Player player, bool resetVictories = true}) {
    setState(() {
      player.score = 0;
      if (resetVictories) {
        player.victories = 0;
        _playerOne.name = "Nós";
        _playerTwo.name = "Eles";
      }
    });
  }

  void _resetPlayer({Player player, bool resetScores = true}) {
    setState(() {
      player.score = 0;
    });
  }

  void _resetScore({bool resetScores = true}) {
    _resetPlayer(player: _playerOne, resetScores: resetScores);
    _resetPlayer(player: _playerTwo, resetScores: resetScores);
  }

  void _resetPlayers({bool resetVictories = true}) {
    _resetTudo(player: _playerOne, resetVictories: resetVictories);
    _resetTudo(player: _playerTwo, resetVictories: resetVictories);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        title: Text(" PLACAR TRUCO"),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              _showDialogReset(
                  title: 'Zerar',
                  message:
                      'Escolaa a opção zerar placar, zerar tudo ou cancelar?',
                  cancel: () {},
                  resetPlayer: () {
                    _resetScore();
                  },
                  resetTudo: () {
                    _resetPlayers();
                  });
            },
            icon: Icon(Icons.refresh),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: _showPlayers(),
      ),
    );
  }

  TextEditingController _nome = TextEditingController();

  void resetFields() {
    _nome.text = '';
  }

  Widget _editPlayerName(Player player) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                  title: Text("Alterar nome"),
                  content: TextFormField(
                    decoration: InputDecoration(hintText: "Novo nome"),
                    controller: _nome,
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Cancelar"),
                      textColor:  Colors.red[900],
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                        child: Text("Ok"),
                        textColor:  Colors.red[900],
                        onPressed: () {
                          setState(() {
                            player.name = _nome.text;
                            Navigator.of(context).pop();
                            if (_playerOne.name == '' && _nome.text == '') {
                              player.name = "Nós";
                            }
                            if (_playerTwo.name == '' && _nome.text == '') {
                              player.name = "eles";
                            }
                            resetFields();
                          });
                        })
                  ]);
            });
      },
      child: Container(child: _showPlayerName(player.name)),
    );
  }

  Widget _showPlayerBoard(Player player) {
    return Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _editPlayerName(player),
          _showPlayerScore(player.score),
          _showPlayerVictories(player.victories),
          _showScoreButtons(player),
        ],
      ),
    );
  }

  Widget _showPlayers() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _showPlayerBoard(_playerOne),
        _showPlayerBoard(_playerTwo),
      ],
    );
  }

  Widget _showPlayerName(String name) {
    return Text(
      name.toUpperCase(),
      style: TextStyle(
          fontSize: 22.0, fontWeight: FontWeight.w500, color: Colors.red[900]),
    );
  }

  Widget _showPlayerVictories(int victories) {
    return Text(
      "vitórias ( $victories )",
      style: TextStyle(fontWeight: FontWeight.w300),
    );
  }

  Widget _showPlayerScore(int score) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 52.0),
      child: Text(
        "$score",
        style: TextStyle(fontSize: 120.0),
      ),
    );
  }

  Widget _buildRoundedButton(
      {String text, double size = 52.0, Color color, Function onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: ClipOval(
        child: Container(
          color: color,
          height: size,
          width: size,
          child: Center(
              child: Text(
            text,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          )),
        ),
      ),
    );
  }

  Widget _showScoreButtons(Player player) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _buildRoundedButton(
          text: '-1',
          color: Colors.black.withOpacity(0.1),
          onTap: () {
            setState(() {
              if (player.score >= 1 && player.score <= 12) player.score--;
            });
          },
        ),
        _buildRoundedButton(
          text: '+1',
          color: Colors.red[900],
          onTap: () {
            setState(() {
              player.score++;
            });

            if (_playerOne.score == 11 && _playerTwo.score == 11)
              _showDialogFerro(
                title: 'Mão de Ferro',
                message: 'BOA SORTE',
              );

            if (player.score == 12) {
              _showDialogGanhou(
                  title: 'Fim do jogo',
                  message: '${player.name} ganhou!',
                  confirm: () {
                    setState(() {
                      player.victories++;
                    });
                    _resetPlayers(resetVictories: false);
                  },
                  cancel: () {
                    setState(() {
                      player.score--;
                    });
                  });
            }
          },
        ),
      ],
    );
  }

  void _showDialogGanhou(
      {String title, String message, Function confirm, Function cancel}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text("CANCEL"),
              textColor: Colors.red[900],
              onPressed: () {
                Navigator.of(context).pop();
                if (cancel != null) cancel();
              },
            ),
            FlatButton(
              child: Text("OK"),
              textColor: Colors.red[900],
              onPressed: () {
                Navigator.of(context).pop();
                if (confirm != null) confirm();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialogFerro({String title, String message, Function confirm}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text("OK"),
              textColor: Colors.red[900],
              onPressed: () {
                Navigator.of(context).pop();
                if (confirm != null) confirm();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialogReset(
      {String title,
      String message,
      Function cancel,
      Function resetPlayer,
      Function resetTudo}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text("CANCEL"),
              textColor: Colors.red[900],
              onPressed: () {
                Navigator.of(context).pop();
                if (cancel != null) cancel();
              },
            ),
            FlatButton(
              child: Text("PLACAR"),
              textColor: Colors.red[900],
              onPressed: () {
                Navigator.of(context).pop();
                if (resetPlayer != null) resetPlayer();
              },
            ),
            FlatButton(
              child: Text("TUDO"),
              textColor: Colors.red[900],
              onPressed: () {
                Navigator.of(context).pop();
                if (resetTudo != null) resetTudo();
              },
            ),
          ],
        );
      },
    );
  }
}
