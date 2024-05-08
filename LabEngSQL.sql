CREATE DATABASE CrudEstoque
GO
USE CrudEstoque

CREATE TABLE Produto (
    codigo INT PRIMARY KEY,
    nome VARCHAR(255),
    validade DATE,
    descricao TEXT,
    valorUnit DECIMAL(10, 2),
    teorAlcoolico DECIMAL(5, 2),
    quantidade INT
);

CREATE PROCEDURE GerenciarProduto (
    @op VARCHAR(10),
    @codigo INT,
    @nome VARCHAR(100),
    @validade DATE,
    @descricao VARCHAR(200),
    @valorUnit DECIMAL(10, 2),
    @teorAlcoolico DECIMAL(5, 2),
    @quantidade INT,
    @saida VARCHAR(100) OUTPUT
)
AS
BEGIN
    IF @codigo < 0 OR @codigo > 100
    BEGIN
        SET @saida = 'O código do produto deve estar entre 0 e 100.';
        RETURN; 
    END

    IF @op = 'I' 
    BEGIN
        IF @codigo IS NOT NULL AND @nome IS NOT NULL AND @validade IS NOT NULL AND @valorUnit IS NOT NULL AND @quantidade IS NOT NULL
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM Produto WHERE codigo = @codigo)
            BEGIN
                INSERT INTO Produto (codigo, nome, validade, descricao, valorUnit, teorAlcoolico, quantidade)
                VALUES (@codigo, @nome, @validade, @descricao, @valorUnit, @teorAlcoolico, @quantidade);
                
                SET @saida = 'Produto inserido com sucesso.';
            END
            ELSE
            BEGIN
                SET @saida = 'O código do produto já existe na base de dados.';
            END
        END
        ELSE
        BEGIN
            SET @saida = 'Parâmetros incompletos para inserção.';
        END
    END
    ELSE IF @op = 'U' 
    BEGIN
        IF @codigo IS NOT NULL AND @nome IS NOT NULL AND @validade IS NOT NULL AND @valorUnit IS NOT NULL AND @quantidade IS NOT NULL
        BEGIN
            IF EXISTS (SELECT 1 FROM Produto WHERE codigo = @codigo)
            BEGIN
                UPDATE Produto
                SET nome = @nome,
                    validade = @validade,
                    descricao = @descricao,
                    valorUnit = @valorUnit,
                    teorAlcoolico = @teorAlcoolico,
                    quantidade = @quantidade
                WHERE codigo = @codigo;

                SET @saida = 'Produto atualizado com sucesso.';
            END
            ELSE
            BEGIN
                SET @saida = 'O código do produto não foi encontrado na base de dados.';
            END
        END
        ELSE
        BEGIN
            SET @saida = 'Parâmetros incompletos para atualização.';
        END
    END
    ELSE IF @op = 'D'
    BEGIN
        IF @codigo IS NOT NULL
        BEGIN
            IF EXISTS (SELECT 1 FROM Produto WHERE codigo = @codigo)
            BEGIN
                DELETE FROM Produto WHERE codigo = @codigo;
                SET @saida = 'Produto excluído com sucesso.';
            END
            ELSE
            BEGIN
                SET @saida = 'O código do produto não foi encontrado na base de dados.';
            END
        END
        ELSE
        BEGIN
            SET @saida = 'Parâmetros incompletos para exclusão.';
        END
    END
    ELSE
    BEGIN
        SET @saida = 'Operação inválida.';
    END
END;


CREATE FUNCTION fnProdutos ()
RETURNS TABLE
AS
RETURN
(
    SELECT
        codigo,
        nome,
        validade,
        descricao,
        valorUnit,
        teorAlcoolico,
        quantidade
    FROM
        Produto
);
