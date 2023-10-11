import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'lista_cidades_brasileiras.dart';

class Principal extends StatefulWidget {
  const Principal({Key? key});

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  String respostaWeb = "";
  String campo = "";
  String nome = "";
  String num = "";
  TextEditingController campoIBGE = TextEditingController();
  TextEditingController campoNome = TextEditingController();

  // Sincrona - Busca e resposta quase imediata
  // Assincrona - Depende de algo, aguardando as informações

  Future<void> getDados(String campo) async {
    String urlApi = "https://apiprevmet3.inmet.gov.br/previsao/$campo";
    http.Response response = await http.get(Uri.parse(urlApi));
    // print(response.body);
    Map<String, dynamic> resposta = json.decode(response.body);
    resposta.remove('icone');
    Map<String, dynamic> mapaPreciso = resposta[campo]['11/10/2023']['manha'];
    mapaPreciso.remove('icone');
    mapaPreciso.remove('temp_max_tende_icone');
    mapaPreciso.remove('temp_min_tende_icone');
    setState(() {
      respostaWeb = "Cidade: ${mapaPreciso['entidade']}\n Temp. Max: ${mapaPreciso['temp_max']}\n Temp. min: ${mapaPreciso['temp_min']}\n Ventos: ${mapaPreciso['int_vento']}\n Resumo: ${mapaPreciso['resumo']}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Clima Cidade"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Image.asset("imagens/temp.jpg",),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: TextField(
                controller: campoNome,
                decoration: InputDecoration(
                  labelText: "Informe o nome. Ex Londrina",
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: TextField(
                controller: campoIBGE,
                decoration: InputDecoration(
                  labelText: "Informe o campo número do IBGE, Ex 4113700",
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    List <String> listaMaiuscula = ListaCidadesBrasilUppercase.listaCidadesBrasilUppercase;
                    List <int> listaNum = ListaCidadesBrasil.listaIdCidades;
                    nome = campoNome.text.toUpperCase();
                    num = campoIBGE.text;
                    if (nome.isEmpty && num.isNotEmpty) {
                      campo = num;
                      print(campo);
                    }else{
                      if(nome.isNotEmpty && num.isEmpty){
                        int indice = listaMaiuscula.indexOf(nome);
                        if(indice != -1){
                          campo = listaNum[indice].toString();
                        }
                      }
                    }

                  });

                  getDados(campo);
                },
                child: Text("Pesquisar".toUpperCase()),
              ),
            ),
            Text(
              respostaWeb,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
