module Correios
  module Sigep
    def self.shipping_xml(data)
      helper = Helper.new
      credentials = Correios.credentials
      sender = data[:sender]
      sender_address = sender[:address]
      shippings = data[:shippings]

      Nokogiri::XML::Builder.new(encoding: 'ISO-8859-1') do |xml|
        xml.correioslog do
          xml.tipo_arquivo 'Postagem'
          xml.versao_arquivo '2.3'
          xml.plp do
            xml.id_plp
            xml.valor_global
            xml.mcu_unidade_postagem
            xml.nome_unidade_postagem
            xml.cartao_postagem credentials.card
          end
          xml.remetente do
            xml.numero_contrato credentials.contract
            xml.numero_diretoria sender[:board_id]
            xml.codigo_administrativo credentials.administrative_code
            xml.nome_remetente sender[:name]
            xml.logradouro_remetente sender_address[:street]
            xml.numero_remetente sender_address[:number]
            xml.complemento_remetente sender_address[:additional]
            xml.bairro_remetente sender_address[:neighborhood]
            xml.cep_remetente sender_address[:zip_code]
            xml.cidade_remetente sender_address[:city]
            xml.uf_remetente sender_address[:state]
            xml.telefone_remetente sender[:phone]
            xml.fax_remetente sender[:fax]
            xml.email_remetente sender[:email]
          end
          xml.forma_pagamento helper.payment_method(data[:payment_method])
          shippings.each do |shipping|
            receiver = shipping[:receiver]
            receiver_address = receiver[:address]
            object = shipping[:object]
            invoice = shipping[:invoice] || {}
            additional_services = shipping[:additional_services] || []
            notes = shipping[:notes] || []

            xml.objeto_postal do
              xml.numero_etiqueta shipping[:label_number]
              xml.codigo_objeto_cliente shipping[:code]
              xml.codigo_servico_postagem shipping[:service_code]
              xml.cubagem 0
              xml.peso object[:weight]
              xml.rt1 notes[0]
              xml.rt2 notes[1]
              xml.destinatario do
                xml.nome_destinatario receiver[:name]
                xml.telefone_destinatario receiver[:phone]
                xml.celular_destinatario receiver[:cellphone]
                xml.email_destinatario receiver[:email]
                xml.logradouro_destinatario receiver_address[:street]
                xml.complemento_destinatario receiver_address[:additional]
                xml.numero_end_destinatario receiver_address[:number]
              end
              xml.nacional do
                xml.bairro_destinatario receiver_address[:neighborhood]
                xml.cidade_destinatario receiver_address[:city]
                xml.uf_destinatario receiver_address[:state]
                xml.cep_destinatario receiver_address[:zip_code]
                xml.codigo_usuario_postal
                xml.centro_custo_cliente shipping[:cost_center]
                xml.numero_nota_fiscal invoice[:number]
                xml.serie_nota_fiscal invoice[:serie]
                xml.valor_nota_fiscal invoice[:value]
                xml.natureza_nota_fiscal invoice[:kind]
                xml.descricao_objeto shipping[:description]
                xml.valor_a_cobrar shipping[:additional_value]
              end
              xml.servico_adicional do
                additional_services.each do |additional_service|
                  xml.codigo_servico_adicional additional_service
                end
                xml.valor_declarado shipping[:declared_value]
              end
              xml.dimensao_objeto do
                xml.tipo_objeto helper.object_type(object[:type])
                xml.dimensao_altura object[:height] || 0
                xml.dimensao_largura object[:width] || 0
                xml.dimensao_comprimento object[:length] || 0
                xml.dimensao_diametro object[:diameter] || 0
              end
              xml.data_postagem_sara
              xml.status_processamento 0
              xml.numero_comprovante_postagem
              xml.valor_cobrado
            end
          end
        end
      end.to_xml.encode(Encoding::UTF_8)
    end
  end
end
