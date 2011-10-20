require 'mechanize'
require "consulta_cep/version"

module ConsultaCep
  class Consulta
    ESTADOS = ['AC', 'AL', 'AM', 'AP', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MG', 'MS', 'MT', 'PA', 'PB', 'PE', 'PI', 'PR', 'RJ', 'RN', 'RO', 'RR', 'RS', 'SC', 'SE', 'SP', 'TO']

    TIPOS = [
      'Aeroporto', 'Alameda', 'Área', 'Avenida', 'Campo', 'Chácara', 'Colônia', 'Condomínio', 'Conjunto', 'Distrito', 'Esplanada', 'Estação', 'Estrada', 'Favela',
      'Fazenda', 'Feira', 'Jardim', 'Ladeira', 'Lago', 'Lagoa', 'Largo', 'Loteamento', 'Morro', 'Núcleo', 'Parque', 'Passarela', 'Pátio', 'Praça', 'Quadra',
      'Recanto', 'Residencial', 'Rodovia', 'Rua', 'Setor', 'Sítio', 'Travessa', 'Trecho', 'Trevo', 'Vale', 'Vereda', 'Via', 'Viaduto', 'Viela', 'Vila'
    ]

    def initialize
      @agent = Mechanize.new
      @agent.user_agent_alias = 'Windows IE 7'
      @last_page = @agent.get 'http://correios.com.br'
    end

    def cep(cep)
      @last_page = @agent.post 'http://www.buscacep.correios.com.br/servicos/dnec/consultaLogradouroAction.do',
        :EndRow       => 10,
        :Metodo       => 'listaLogradouro',
        :StartRow     => 1,
        :TipoConsulta => 'cep',
        :CEP          => cep

      parse_lista @last_page
    end

    def endereco(endereco)
      @last_page = @agent.post 'http://www.buscacep.correios.com.br/servicos/dnec/consultaLogradouroAction.do',
        :EndRow       => 10,
        :Metodo       => 'listaLogradouro',
        :StartRow     => 1,
        :TipoCep      => 'LOG',
        :TipoConsulta => 'relaxation',
        :cfm          => 1,
        :relaxation   => endereco,
        :semelhante   => 'S'

      parse_lista @last_page
    end

    def endereco_refinado(endereco, params)
      @last_page = @agent.post 'http://www.buscacep.correios.com.br/servicos/dnec/consultaLogradouroAction.do',
        :EndRow       => 10,
        :Localidade   => params[:cidade],
        :Logradouro   => endereco,
        :Metodo       => 'listaLogradouro',
        :Numeor       => params[:numero],
        :StartRow     => 1,
        :Tipo         => (params[:tipo] || ''),
        :TipoConsulta => 'logradouro',
        :UF           => params[:estado],
        :cfm          => 1

      parse_lista @last_page
    end

    def self.cep(cep_number)
      self.new.cep cep_number.gsub(/[^\d]/, '')
    end

    def self.endereco(endereco)
      self.new.endereco endereco
    end

    def self.endereco_refinado(endereco, params={})
      self.new.endereco_refinado endereco, params
    end

    protected
    def parse_lista(page)
      elements = []
      page.search('tr[@onclick]').each do |row|
        data = row.search('td').map &:text
        element = {
          :endereco => data[0],
          :bairro   => data[1],
          :cidade   => data[2],
          :estado   => data[3],
          :cep      => data[4]
        }
        elements << element
      end
      elements
    end
  end
end

include ConsultaCep

Consulta.cep '12228462'
Consulta.endereco 'Rua Alice Costa, 39'
Consulta.endereco_refinado 'H8C', :cidade => 'São José dos Campos', :estado => 'SP'
