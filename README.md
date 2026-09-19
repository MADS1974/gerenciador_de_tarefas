# 📋 Gerenciador de Tarefas - IFSP

Este é um aplicativo mobile desenvolvido em **Flutter/Dart** com foco na persistência de dados utilizando armazenamento local em **SQLite**. O projeto foi construído para cumprir os requisitos da Avaliação 1 de desenvolvimento multiplataforma, demonstrando a implementação de operações CRUD (Criar, Ler, Atualizar e Deletar) completas.

---

## 🚀 Funcionalidades Implementadas

* **Listagem Dinâmica:** Tela principal que exibe todas as tarefas cadastradas, lidas diretamente do banco de dados local.
* **Cadastro de Itens:** Interface de formulário para inserção de novos registros, capturando o título e gerando automaticamente a data e a hora da criação.
* **Gestão de Status:** Capacidade de atualizar uma atividade e marcá-la como "Tarefa Concluída", aplicando um feedback visual imediato na lista principal (texto rasurado e ícone de validação).
* **Exclusão Segura:** Opção para deletar itens existentes mediante um alerta de confirmação em tela.

---

## 🛠️ Tecnologias e Pacotes

A arquitetura do projeto foi estruturada utilizando as seguintes ferramentas:

* 🎯 **Linguagem:** Dart
* 📱 **Framework:** Flutter
* 🗄️ **Banco de Dados:** SQLite
* 📦 **Dependências Principais:** 
  * `sqflite`: Para manipulação e execução de instruções SQL.
  * `path`: Para o mapeamento correto de caminhos de diretórios físicos no dispositivo Android/iOS.

---

## 🗃️ Estrutura de Dados

A base de dados local possui uma tabela principal chamada `tarefas`, que é estruturada com 4 colunas essenciais para o funcionamento do aplicativo:

* `id` **(INTEGER):** Chave Primária com Autoincremento.
* `titulo` **(TEXT):** Armazena a descrição da atividade.
* `data` **(TEXT):** Regista o momento exato da criação da tarefa.
* `concluida` **(INTEGER):** Atua como um controle booleano nativo do SQLite (`0` para tarefa pendente, `1` para tarefa concluída).
