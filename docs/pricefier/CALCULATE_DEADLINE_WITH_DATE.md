## Calcular Prazo de Entrega com Data

Documentação dos Correios: `CalcPrazoData`

Calcula a data máxima de entrega de uma encomenda entre dois CEPs considerando o serviço utilizado e uma data de
referência para a postagem.

____

### Autenticação
Nenhuma credencial necessária.

### Exemplo de entrada

```ruby
require 'correios_gem'
...
Correios::Pricefier.calculate_deadline_with_date({
  service_codes: ['04162','04669'],
  source_zip_code: '32145000',
  target_zip_code: '32140530',
  reference_date: Date.new(2017,2,3)
})

```
* O campo `service_codes[i]` deve ser preenchido com os códigos dos serviços conforme método [Buscar Cliente](../sigep/SEARCH_CUSTOMER.md), [Listar Serviços](LIST_SERVICES.md) ou [Listar Serviços STAR](LIST_SERVICES_STAR.md).

### Saída

```ruby
{
  :services => [
    {
      :code => '4162',
      :delivery_at_home => true,
      :delivery_on_saturdays => true,
      :note => nil,
      :deadline => {
        :days => 1,
        :date => Mon, 06 Feb 2017 # Campo tipo Date 
      }
    },
    {
      :code => '4669',
      :error => {
        :code => '008',
        :description => 'Serviço indisponível para o trecho informado.''
      }
    }
  ]
}
```
* O campo `services[i].deadline.days` é a quantidade de dias que os Correios terão para entregar a encomenda.
* O campo `services[i].deadline.date` é a data limite que os Correios terão para entregar a encomenda.
---

[Consultar documentação dos Correios](http://ws.correios.com.br/calculador/CalcPrecoPrazo.asmx)
