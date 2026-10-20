
#!/bin/bash

ARQUIVO="dados.json"

[ -f "$ARQUIVO" ] || echo "{}" > "$ARQUIVO"

while true; do
    echo
    echo "1) Cadastrar dados"
    echo "2) Buscar pelo nome"
    echo "3) Sair"
    read -r -p "> " opcao

    case "$opcao" in
        1)
            read -r -p "Nome: " nome
            read -r -p "Data de nascimento: " nascimento
            read -r -p "Número de Celular: " numero
            read -r -p "Outras informações: " outras
            read -r -p "Valor Pego: " valor
            read -r -p "Valor de Vota: " dvolta

            # Escapa os valores para JSON usando jq
            registro=$(jq -n \
                --arg nome "$nome" \
                --arg nascimento "$nascimento" \
                --arg numero "$numero" \
                --arg outras "$outras" \
                --arg valor "$valor" \
                --arg dvolta " $dvolta" \
                '{
                    nome: $nome,
                    data_nascimento: $nascimento,
                    numero: $numero,
                    outras_informacoes: $outras,
                    valor_pego: $valor,
                    valor_volta: $dvolta
                }')

            # Guarda o registro usando o nome como chave
            tmp=$(mktemp)
            jq --arg nome "$nome" \
               --argjson registro "$registro" \
               '.[$nome] = $registro' \
               "$ARQUIVO" > "$tmp" &&
               mv "$tmp" "$ARQUIVO"

            echo "Dados salvos!"
            ;;

        2)
            read -r -p "Nome para buscar: " nome
            jq --arg nome "$nome" '.[$nome] // "Nome não encontrado"' "$ARQUIVO"
            ;;

        3)
            break
            ;;

        *)
            echo "Opção inválida."
            ;;
    esac
done
