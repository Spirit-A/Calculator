import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const Calculatrice());
}

class Calculatrice extends StatelessWidget {
  const Calculatrice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Calculator",
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey[250],
      ),
      home: SimpleCalculatrice(),
    );
  }
}

class SimpleCalculatrice extends StatefulWidget {
  @override
  _SimpleCalculatriceState createState() => _SimpleCalculatriceState();
}

class _SimpleCalculatriceState extends State<SimpleCalculatrice> {
  String equation = "";
  String result = "0";
  String expression = "";
  bool hasError = false;

  void _updateDisplayText(String text) {
    setState(() {
      if (text == "C") {
        // Réinitialiser le texte d'affichage
        equation = "";
        result = "0";
        expression = "";
        hasError = false;
      } else if (text == "⌫") {
        // Supprimer le dernier caractère
        if (!hasError && equation.isNotEmpty) {
          equation = equation.substring(0, equation.length - 1);
        } else {
          equation = "";
          hasError = false;
        }
      } else if (text == "=") {
        // Évaluer l'expression mathématique
        if (equation.isNotEmpty) {
          try {
            expression = equation;

            // Remplacer les symboles personnalisés par les symboles mathématiques standard
            expression = expression.replaceAll("×", "*");
            expression = expression.replaceAll("÷", "/");
            expression = expression.replaceAll("%", "%");

            // Utiliser une bibliothèque ou une logique pour évaluer l'expression
            Parser p = Parser();
            Expression exp = p.parse(expression);
            ContextModel cm = ContextModel();
            result = exp.evaluate(EvaluationType.REAL, cm).toString();

            hasError = false;
          } catch (e) {
            result = "Erreur de syntaxe";
            hasError = true;
          }
        }
      } else {
        // Ajouter le texte au niveau de l'équation
        if (hasError) {
          equation = "";
          hasError = false;
        }

        if (result != "0") {
          equation = result;
          result = "0";
        }

        equation += text;
      }
    });
  }

  Widget calculatriceBtn(String textBtn, Color colorBtn, Color colorText) {
    return GestureDetector(
      onTap: () {
        _updateDisplayText(textBtn);
      },
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: colorBtn,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 3),
              blurRadius: 6,
            ),
          ],
        ),
        child: Center(
          child: Text(
            textBtn,
            style: TextStyle(
              color: colorText,
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final gridHeight = screenHeight - (0.4 * MediaQuery.of(context).devicePixelRatio);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Calculatrice",
          style: TextStyle(
            color: Color(0xFFE57373),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[800],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 10, 0),
                  child: Text(
                    equation,
                    style: const TextStyle(fontSize: 35),
                  ),
                ),
                if (!hasError)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 30, 10, 0),
                    child: Text(
                      result,
                      style: const TextStyle(fontSize: 35),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            flex: 8,
            child: SizedBox(
              height: gridHeight,
              child: GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  calculatriceBtn("C", Colors.redAccent, Colors.white),
                  calculatriceBtn("⌫", Colors.blueGrey, Colors.white),
                  calculatriceBtn("%", Colors.blueGrey, Colors.white),
                  calculatriceBtn("÷", Colors.blueGrey, Colors.white),
                  calculatriceBtn("7", Colors.grey[300]!, Colors.black),
                  calculatriceBtn("8", Colors.grey[300]!, Colors.black),
                  calculatriceBtn("9", Colors.grey[300]!, Colors.black),
                  calculatriceBtn("×", Colors.blueGrey, Colors.white),
                  calculatriceBtn("4", Colors.grey[300]!, Colors.black),
                  calculatriceBtn("5", Colors.grey[300]!, Colors.black),
                  calculatriceBtn("6", Colors.grey[300]!, Colors.black),
                  calculatriceBtn("-", Colors.blueGrey, Colors.white),
                  calculatriceBtn("1", Colors.grey[300]!, Colors.black),
                  calculatriceBtn("2", Colors.grey[300]!, Colors.black),
                  calculatriceBtn("3", Colors.grey[300]!, Colors.black),
                  calculatriceBtn("+", Colors.blueGrey, Colors.white),
                  calculatriceBtn("00", Colors.grey[300]!, Colors.black),
                  calculatriceBtn("0", Colors.grey[300]!, Colors.black),
                  calculatriceBtn(".", Colors.grey[300]!, Colors.black),
                  calculatriceBtn("=", Colors.redAccent, Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
