DEFINE TABLE usuario TYPE SCHEMAFULL;
DEFINE FIELD OVERWRITE login ON usuario TYPE string ASSERT $value.len() > 2;
DEFINE FIELD OVERWRITE email ON usuario TYPE string ASSERT string::is::email($value);
DEFINE FIELD OVERWRITE senha ON usuario TYPE string ASSERT $value.len() > 5;
DEFINE FIELD OVERWRITE nome ON usuario TYPE string ASSERT $value.len() > 2;
DEFINE FIELD OVERWRITE cargo ON usuario TYPE 'ADMIN' | 'FUNCIONARIO'  ASSERT $value.len() > 2;
DEFINE FIELD OVERWRITE lojista ON usuario TYPE string;
DEFINE FIELD OVERWRITE criadoEm							ON usuario TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD OVERWRITE canceladoEm					ON usuario TYPE datetime | null DEFAULT null;
DEFINE FIELD OVERWRITE atualizadoEm					ON usuario TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;

-- Tabela de lojistas/tenants
DEFINE TABLE lojista TYPE SCHEMAFULL;
DEFINE FIELD OVERWRITE identificador ON lojista TYPE string ASSERT $value.len() > 1; -- Ex: "jag", "utilar", "JL"
DEFINE FIELD OVERWRITE nomeEmpresa ON lojista TYPE string ASSERT $value.len() > 2;
DEFINE FIELD OVERWRITE urlSistema ON lojista TYPE string;
DEFINE FIELD OVERWRITE email ON lojista TYPE string ASSERT string::is::email($value);
DEFINE FIELD OVERWRITE telefone ON lojista TYPE string;
DEFINE FIELD OVERWRITE criadoEm ON lojista TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD OVERWRITE canceladoEm ON lojista TYPE datetime | null DEFAULT null;
DEFINE FIELD OVERWRITE atualizadoEm ON lojista TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;

-- Mensagens com origem (lojista ou atendente)
DEFINE TABLE mensagem TYPE SCHEMAFULL;
DEFINE FIELD OVERWRITE ticket ON mensagem TYPE record<ticket>;
DEFINE FIELD OVERWRITE origem ON mensagem TYPE string VALUE $value = 'LOJISTA' OR $value = 'ATENDENTE';
DEFINE FIELD OVERWRITE usuario ON mensagem TYPE record<usuario> | null; -- Preenchido apenas se origem = 'ATENDENTE'
DEFINE FIELD OVERWRITE usuarioNomeLojista ON mensagem TYPE string | null; -- Preenchido apenas se origem = 'LOJISTA'
DEFINE FIELD OVERWRITE descricao ON mensagem TYPE string ASSERT $value.len() > 2;
DEFINE FIELD OVERWRITE criadoEm ON mensagem TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD OVERWRITE canceladoEm ON mensagem TYPE datetime | null DEFAULT null;
DEFINE FIELD OVERWRITE atualizadoEm ON mensagem TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;

-- Tickets vinculados ao lojista
DEFINE TABLE ticket TYPE SCHEMAFULL;
DEFINE FIELD OVERWRITE titulo ON ticket TYPE string ASSERT $value.len() > 2;
DEFINE FIELD OVERWRITE status ON ticket TYPE record<ticketStatus>;
DEFINE FIELD OVERWRITE lojista ON ticket TYPE record<lojista>;
DEFINE FIELD OVERWRITE usuarioNomeLojista ON ticket TYPE string; -- Nome do usuário do sistema do lojista que abriu o ticket
DEFINE FIELD OVERWRITE atendente ON ticket TYPE record<usuario> | null;
DEFINE FIELD OVERWRITE prioridade ON ticket TYPE string VALUE $value = 'BAIXA' OR $value = 'MEDIA' OR $value = 'ALTA' OR $value = 'URGENTE' DEFAULT 'MEDIA';
DEFINE FIELD OVERWRITE prazoAtendimento ON ticket TYPE datetime | null;
DEFINE FIELD OVERWRITE finalizadoEm ON ticket TYPE datetime | null;
DEFINE FIELD OVERWRITE avaliacaoCliente ON ticket TYPE number ASSERT $value >= 1 AND $value <= 5;
DEFINE FIELD OVERWRITE versaoSistema ON ticket TYPE string; -- Versão do sistema do lojista quando abriu o ticket
DEFINE FIELD OVERWRITE criadoEm ON ticket TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD OVERWRITE canceladoEm ON ticket TYPE datetime | null DEFAULT null;
DEFINE FIELD OVERWRITE atualizadoEm ON ticket TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;

-- Histórico de mudanças de status
DEFINE TABLE statusHistorico TYPE SCHEMAFULL;
DEFINE FIELD OVERWRITE ticket ON statusHistorico TYPE record<ticket>;
DEFINE FIELD OVERWRITE mensagem ON statusHistorico TYPE record<mensagem>;
DEFINE FIELD OVERWRITE usuario ON statusHistorico TYPE record<usuario>;
DEFINE FIELD OVERWRITE statusAntigo ON statusHistorico TYPE record<ticketStatus>;
DEFINE FIELD OVERWRITE statusNovo ON statusHistorico TYPE record<ticketStatus>;
DEFINE FIELD OVERWRITE criadoEm ON statusHistorico TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;

-- Anexos das mensagens
DEFINE TABLE anexo TYPE SCHEMAFULL;
DEFINE FIELD OVERWRITE mensagem ON anexo TYPE record<mensagem>;
DEFINE FIELD OVERWRITE nome ON anexo TYPE string ASSERT $value.len() > 2;
DEFINE FIELD OVERWRITE url ON anexo TYPE string ASSERT $value.len() > 2;
DEFINE FIELD OVERWRITE tamanho ON anexo TYPE number;
DEFINE FIELD OVERWRITE tipo ON anexo TYPE string;
DEFINE FIELD OVERWRITE criadoEm ON anexo TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD OVERWRITE canceladoEm ON anexo TYPE datetime | null DEFAULT null;
DEFINE FIELD OVERWRITE atualizadoEm ON anexo TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;

-- Controle de leitura
DEFINE TABLE leitura TYPE SCHEMAFULL;
DEFINE FIELD OVERWRITE mensagem ON leitura TYPE record<mensagem>;
DEFINE FIELD OVERWRITE usuario ON leitura TYPE record<usuario>;
DEFINE FIELD OVERWRITE lidoEm ON leitura TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;
DEFINE FIELD OVERWRITE criadoEm ON leitura TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD OVERWRITE canceladoEm ON leitura TYPE datetime | null DEFAULT null;
DEFINE FIELD OVERWRITE atualizadoEm ON leitura TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;
