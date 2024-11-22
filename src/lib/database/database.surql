DEFINE TABLE usuario SCHEMAFULL;
DEFINE FIELD OVERWRITE login ON usuario TYPE string ASSERT $value.len() > 2;
DEFINE FIELD OVERWRITE email ON usuario TYPE string ASSERT string::is::email($value);
DEFINE FIELD OVERWRITE senha ON usuario TYPE string ASSERT $value.len() > 5;
DEFINE FIELD OVERWRITE nome ON usuario TYPE string ASSERT $value.len() > 2;
DEFINE FIELD OVERWRITE cargo ON usuario TYPE 'ADMIN' | 'FUNCIONARIO' ASSERT $value.len() > 2;
DEFINE FIELD OVERWRITE criadoEm ON usuario TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD OVERWRITE canceladoEm ON usuario TYPE datetime | null DEFAULT null;
DEFINE FIELD OVERWRITE atualizadoEm ON usuario TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;

DEFINE TABLE lojista SCHEMAFULL;
DEFINE FIELD OVERWRITE identificador ON lojista TYPE string ASSERT $value.len() > 1; -- Identificador único do lojista no ERP
DEFINE FIELD OVERWRITE nomeEmpresa ON lojista TYPE string ASSERT $value.len() > 2;
DEFINE FIELD OVERWRITE email ON lojista TYPE string ASSERT string::is::email($value);
DEFINE FIELD OVERWRITE telefone ON lojista TYPE string;
DEFINE FIELD OVERWRITE criadoEm ON lojista TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD OVERWRITE canceladoEm ON lojista TYPE datetime | null DEFAULT null;
DEFINE FIELD OVERWRITE atualizadoEm ON lojista TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;

DEFINE TABLE ticketStatus SCHEMAFULL;
DEFINE FIELD OVERWRITE descricao ON ticketStatus TYPE string ASSERT $value.len() > 2;
DEFINE FIELD OVERWRITE cor ON ticketStatus TYPE string ASSERT string::is::hexadecimal($value) > 2;
DEFINE FIELD OVERWRITE ordem ON ticketStatus TYPE number ASSERT $value >= 0;
DEFINE FIELD OVERWRITE criadoEm ON ticketStatus TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD OVERWRITE canceladoEm ON ticketStatus TYPE datetime | null DEFAULT null;
DEFINE FIELD OVERWRITE atualizadoEm ON ticketStatus TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;

DEFINE TABLE ticket SCHEMAFULL;
DEFINE FIELD OVERWRITE titulo ON ticket TYPE string ASSERT $value.len() > 2;
DEFINE FIELD OVERWRITE codigo ON ticket TYPE string VALUE fn::gerarCodigoTicket() READONLY;
DEFINE FIELD OVERWRITE status ON ticket TYPE record<ticketStatus>;
DEFINE FIELD OVERWRITE lojista ON ticket TYPE record<lojista>;
DEFINE FIELD OVERWRITE usuarioLojistaId ON ticket TYPE string; -- ID do usuário do ERP que criou o ticket
DEFINE FIELD OVERWRITE usuarioLojistaNome ON ticket TYPE string; -- Nome do usuário do ERP que criou o ticket
DEFINE FIELD OVERWRITE atendente ON ticket TYPE record<usuario> | null;
DEFINE FIELD OVERWRITE prioridade ON ticket TYPE string VALUE $value = 'BAIXA' OR $value = 'MEDIA' OR $value = 'ALTA' OR $value = 'URGENTE' DEFAULT 'MEDIA';
DEFINE FIELD OVERWRITE finalizadoEm ON ticket TYPE datetime | null;
DEFINE FIELD OVERWRITE avaliacaoCliente ON ticket TYPE number ASSERT $value >= 1 AND $value <= 5;
DEFINE FIELD OVERWRITE versaoSistema ON ticket TYPE string;
DEFINE FIELD OVERWRITE visibilidade ON ticket TYPE 'PUBLICO' | 'ADMIN' DEFAULT 'PUBLICO';
DEFINE FIELD OVERWRITE criadoEm ON ticket TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD OVERWRITE canceladoEm ON ticket TYPE datetime | null DEFAULT null;
DEFINE FIELD OVERWRITE atualizadoEm ON ticket TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;

DEFINE TABLE mensagem SCHEMAFULL;
DEFINE FIELD OVERWRITE ticket ON mensagem TYPE record<ticket>;
DEFINE FIELD OVERWRITE usuario ON mensagem TYPE record<usuario> | null; -- Preenchido quando é mensagem do suporte
DEFINE FIELD OVERWRITE usuarioLojistaId ON mensagem TYPE string | null; -- ID do usuário do ERP quando é mensagem do lojista
DEFINE FIELD OVERWRITE usuarioLojistaNome ON mensagem TYPE string | null; -- Nome do usuário do ERP quando é mensagem do lojista
DEFINE FIELD OVERWRITE descricao ON mensagem TYPE string ASSERT $value.len() > 2;
DEFINE FIELD OVERWRITE criadoEm ON mensagem TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD OVERWRITE canceladoEm ON mensagem TYPE datetime | null DEFAULT null;
DEFINE FIELD OVERWRITE atualizadoEm ON mensagem TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;

-- Histórico de mudanças de status
DEFINE TABLE statusHistorico SCHEMAFULL;
DEFINE FIELD OVERWRITE ticket ON statusHistorico TYPE record<ticket>;
DEFINE FIELD OVERWRITE mensagem ON statusHistorico TYPE record<mensagem>;
DEFINE FIELD OVERWRITE usuario ON statusHistorico TYPE record<usuario>;
DEFINE FIELD OVERWRITE statusAntigo ON statusHistorico TYPE record<ticketStatus>;
DEFINE FIELD OVERWRITE statusNovo ON statusHistorico TYPE record<ticketStatus>;
DEFINE FIELD OVERWRITE criadoEm ON statusHistorico TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;

-- Anexos das mensagens
DEFINE TABLE anexo SCHEMAFULL;
DEFINE FIELD OVERWRITE mensagem ON anexo TYPE record<mensagem>;
DEFINE FIELD OVERWRITE nome ON anexo TYPE string ASSERT $value.len() > 2;
DEFINE FIELD OVERWRITE url ON anexo TYPE string ASSERT $value.len() > 2;
DEFINE FIELD OVERWRITE tamanho ON anexo TYPE number;
DEFINE FIELD OVERWRITE tipo ON anexo TYPE string;
DEFINE FIELD OVERWRITE criadoEm ON anexo TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD OVERWRITE canceladoEm ON anexo TYPE datetime | null DEFAULT null;
DEFINE FIELD OVERWRITE atualizadoEm ON anexo TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;

-- Controle de leitura
DEFINE TABLE leitura SCHEMAFULL;
DEFINE FIELD OVERWRITE mensagem ON leitura TYPE record<mensagem>;
DEFINE FIELD OVERWRITE usuario ON leitura TYPE record<usuario>;
DEFINE FIELD OVERWRITE lidoEm ON leitura TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;
DEFINE FIELD OVERWRITE criadoEm ON leitura TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD OVERWRITE canceladoEm ON leitura TYPE datetime | null DEFAULT null;
DEFINE FIELD OVERWRITE atualizadoEm ON leitura TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;

DEFINE FUNCTION OVERWRITE fn::gerarCodigoTicket() {
  LET $grupo1 = rand::int(100, 999);
  LET $grupo2 = rand::int(100, 999);
  LET $grupo3 = rand::int(100, 999);
  -- Junta os grupos com hífen
  RETURN $grupo1 + "-" + $grupo2 + "-" + $grupo3;
}