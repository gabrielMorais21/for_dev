FEATURE:login
como um cliente 
Quero poder acessar minha conta e me manter 
Para que eu possa responder enquetes de forma rapida 

Cenario: Credenciais Válidas 
Dado que o cliente informou credenciais válidas
Quando solicitar para fazer login   
Entao o sistema deve enviar o usuario para a tela de pesquisas 
E manter o usuario conectado 

Cenario: Credenciais Invalidas
Dado que o cliente informou credenciais Invalidas
Quando solicitar para fazer login 
Entao o sistema deve retornar uma mensagem de erro  