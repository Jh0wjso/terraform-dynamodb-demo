# terraform-dynamodb-demo

Projeto Terraform de demonstração que provisiona uma tabela DynamoDB com um módulo reutilizável, além de uma IAM Role e Policy para acesso via EC2.

## Estrutura

```
.
├── main.tf                          # Provider, módulo e recursos IAM
├── outputs.tf                       # Outputs raiz
└── modules/
    ├── dynamodb_table/              # Módulo parametrizado (recomendado)
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── dynamodb_table_hardcoded/    # Módulo com valores fixos (referência)
```

## Pré-requisitos

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.0
- AWS CLI configurado com credenciais válidas
- Permissões para criar recursos DynamoDB e IAM

## Uso

```bash
terraform init
terraform plan
terraform apply
```

## Recursos provisionados

| Recurso | Descrição |
|---|---|
| `aws_dynamodb_table` | Tabela `users-dev` com billing `PAY_PER_REQUEST` e hash key `id` |
| `aws_iam_role` | Role assumível por EC2 para acesso à tabela |
| `aws_iam_policy` | Policy com permissões de leitura e escrita no DynamoDB |
| `aws_iam_role_policy_attachment` | Vincula a policy à role |

## Módulo `dynamodb_table`

### Inputs

| Nome | Descrição | Tipo | Obrigatório |
|---|---|---|---|
| `table_name` | Nome base da tabela | `string` | sim |
| `environment` | Ambiente (ex: dev, staging, prod) | `string` | sim |

### Outputs

| Nome | Descrição |
|---|---|
| `table_name` | Nome completo da tabela (`<table_name>-<environment>`) |
| `table_arn` | ARN da tabela DynamoDB |

## Outputs raiz

| Nome | Descrição |
|---|---|
| `table_name` | Nome completo da tabela |
| `table_arn` | ARN da tabela |
| `ec2_iam_role_arn` | ARN da IAM Role para EC2 |

## Destruir recursos

```bash
terraform destroy
```
