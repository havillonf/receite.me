--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

-- Started on 2025-07-24 09:47:23

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

-- ALTER TABLE ONLY public.pastas DROP CONSTRAINT id_usuarios;
-- ALTER TABLE ONLY public.pastas_receitas DROP CONSTRAINT id_receitas;
-- ALTER TABLE ONLY public.receitas_ingredientes DROP CONSTRAINT id_receitas;
-- ALTER TABLE ONLY public.pastas_receitas DROP CONSTRAINT id_pastas;
-- ALTER TABLE ONLY public.receitas_ingredientes DROP CONSTRAINT id_ingredientes;
-- DROP TRIGGER trigger_val_nutr_rec ON public.receitas_ingredientes;
-- DROP TRIGGER trigger3 ON public.pastas;
-- DROP TRIGGER trigger2 ON public.usuarios;
-- DROP TRIGGER trigger1 ON public.usuarios;
-- ALTER TABLE ONLY public.usuarios DROP CONSTRAINT usuarios_pkey;
-- ALTER TABLE ONLY public.usuarios DROP CONSTRAINT usuarios_email_key;
-- ALTER TABLE ONLY public.receitas DROP CONSTRAINT receitas_pkey;
-- ALTER TABLE ONLY public.receitas_ingredientes DROP CONSTRAINT receitas_ingredientes_pkey;
-- ALTER TABLE ONLY public.pastas_receitas DROP CONSTRAINT receitas_das_pastas_pkey;
-- ALTER TABLE ONLY public.ingredientes DROP CONSTRAINT ingredientes_pkey;
-- ALTER TABLE ONLY public.pastas DROP CONSTRAINT "Favoritos_pkey";
-- DROP TABLE public.usuarios;
-- DROP TABLE public.receitas_ingredientes;
-- DROP TABLE public.receitas;
-- DROP TABLE public.pastas_receitas;
-- DROP TABLE public.pastas;
-- DROP TABLE public.ingredientes;
-- DROP FUNCTION public.trigger3_function();
-- DROP FUNCTION public.trigger2_function();
-- DROP FUNCTION public.trigger1_function();
-- DROP FUNCTION public.func_val_nutr_rec();
--
-- TOC entry 223 (class 1255 OID 16468)
-- Name: func_val_nutr_rec(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.func_val_nutr_rec() RETURNS trigger
    LANGUAGE plpgsql
    AS $$


DECLARE
	"CAL_T" REAL;
	"PRO_T" REAL;
	"CAR_T" REAL;
	"GOR_T" REAL;
	"x" REAL;
	"qtd_stored" REAL;
	"CAL_I" REAL;
	"PRO_I" REAL;
	"CAR_I" REAL;
	"GOR_I" REAL;

BEGIN
	IF TG_OP = 'INSERT' THEN
		SELECT I."quantidade",I."calorias",I."proteinas",I."carboidratos",I."gorduras" INTO "qtd_stored","CAL_I","PRO_I","CAR_I","GOR_I"
		FROM "ingredientes" AS I
		WHERE I."id" = new."ingrediente_id";
		
		"x" := new."quantidade" / "qtd_stored";
		
		SELECT R."calorias_totais", R."proteinas_totais", R."carboidratos_totais", R."gorduras_totais"
		INTO "CAL_T", "PRO_T", "CAR_T", "GOR_T"
		FROM "receitas" AS R
		WHERE R."id" = new."receita_id";
		
		"CAL_T" := "CAL_T" + ("CAL_I" * "x");
		"PRO_T" := "PRO_T" + ("PRO_I" * "x");
		"CAR_T" := "CAR_T" + ("CAR_I" * "x");
		"GOR_T" := "GOR_T" + ("GOR_I" * "x");
		
		UPDATE "receitas" SET
			"calorias_totais" = "CAL_T",
			"proteinas_totais" = "PRO_T",
			"carboidratos_totais" = "CAR_T",
			"gorduras_totais" = "GOR_T"
		WHERE "id" = new."receita_id";
		
		RETURN new;
	END IF;
END;
$$;


ALTER FUNCTION public.func_val_nutr_rec() OWNER TO postgres;

--
-- TOC entry 224 (class 1255 OID 16469)
-- Name: trigger1_function(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trigger1_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    max_id_user bigint;
BEGIN
    IF (TG_OP = 'INSERT') THEN
        SELECT MAX("id") + 1 INTO max_id_user
        FROM "usuarios";
        
        NEW."id" := max_id_user;
        
        -- Define uma variável de controle para indicar que a primeira trigger foi executada
    END IF;
    
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger1_function() OWNER TO postgres;

--
-- TOC entry 225 (class 1255 OID 16470)
-- Name: trigger2_function(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trigger2_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    max_id_p bigint;
BEGIN
    IF (TG_OP = 'INSERT') THEN
        -- Verifica se a primeira trigger foi executada
            SELECT MAX("id") + 1 INTO max_id_p
            FROM "pastas";
            
            INSERT INTO "pastas" ("nome", "id", "flag_favorito", "usuario_id")
            VALUES ('favoritas', max_id_p, true, NEW."id");
    END IF;
    
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger2_function() OWNER TO postgres;

--
-- TOC entry 226 (class 1255 OID 16471)
-- Name: trigger3_function(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trigger3_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    max_id_recipe bigint;
BEGIN
    IF (TG_OP = 'INSERT') THEN
        SELECT MAX("id") + 1 INTO max_id_recipe
        FROM "pastas";
        NEW."id" := max_id_recipe;
    END IF;
    
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger3_function() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 217 (class 1259 OID 16472)
-- Name: ingredientes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ingredientes (
    nome text,
    calorias real,
    proteinas real,
    carboidratos real,
    gorduras real,
    medida text,
    quantidade real,
    id bigint NOT NULL
);


ALTER TABLE public.ingredientes OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16477)
-- Name: pastas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pastas (
    nome text,
    id bigint NOT NULL,
    flag_favorito boolean,
    usuario_id bigint
);


ALTER TABLE public.pastas OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16482)
-- Name: pastas_receitas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pastas_receitas (
    receitas_id bigint NOT NULL,
    pasta_id bigint NOT NULL
);


ALTER TABLE public.pastas_receitas OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16485)
-- Name: receitas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receitas (
    nome text NOT NULL,
    modo_de_preparo text NOT NULL,
    tempo_de_preparo real NOT NULL,
    calorias_totais real DEFAULT 0,
    proteinas_totais real DEFAULT 0,
    carboidratos_totais real DEFAULT 0,
    gorduras_totais real DEFAULT 0,
    path_imagem text,
    flag_gluten boolean,
    flag_lactose boolean,
    flag_vegetariano boolean,
    flag_doce boolean,
    flag_salgado boolean,
    id bigint NOT NULL
);


ALTER TABLE public.receitas OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16494)
-- Name: receitas_ingredientes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receitas_ingredientes (
    quantidade double precision NOT NULL,
    receita_id bigint NOT NULL,
    ingredientes_id bigint NOT NULL
);


ALTER TABLE public.receitas_ingredientes OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16497)
-- Name: usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuarios (
    email text NOT NULL,
    nome text NOT NULL,
    senha text NOT NULL,
    avatar text,
    bio text,
    id bigint NOT NULL,
    cargo text NOT NULL,
    codigo_senha text
);


ALTER TABLE public.usuarios OWNER TO postgres;

--
-- TOC entry 4836 (class 0 OID 16472)
-- Dependencies: 217
-- Data for Name: ingredientes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ingredientes VALUES ('Abobora', 26, 1, 6.5, 0.1, 'Gramas', 100, 3);
INSERT INTO public.ingredientes VALUES ('Abobrinha', 21, 1.4, 3.3, 0.3, 'Gramas', 100, 4);
INSERT INTO public.ingredientes VALUES ('Acerola', 32, 0.4, 7.7, 0.3, 'Gramas', 100, 5);
INSERT INTO public.ingredientes VALUES ('Alface americana', 15, 1.2, 2.9, 0.2, 'Gramas', 100, 6);
INSERT INTO public.ingredientes VALUES ('Alho-poro', 54, 1.8, 12.6, 0.3, 'Gramas', 100, 8);
INSERT INTO public.ingredientes VALUES ('Azeite de oliva', 120, 0, 0, 14, 'ML', 100, 11);
INSERT INTO public.ingredientes VALUES ('Carne Bovina ', 250, 25, 0, 17, 'Gramas', 100, 17);
INSERT INTO public.ingredientes VALUES ('Cebolinha verde', 32, 2.5, 4.4, 0.6, 'Gramas', 100, 20);
INSERT INTO public.ingredientes VALUES ('Espinafre', 23, 2.9, 3.6, 0.4, 'Gramas', 100, 25);
INSERT INTO public.ingredientes VALUES ('Grao de bico', 269, 8.9, 45, 4.1, 'Gramas', 100, 27);
INSERT INTO public.ingredientes VALUES ('Graviola', 67, 1, 16.8, 0.3, 'Gramas', 100, 28);
INSERT INTO public.ingredientes VALUES ('Iogurte grego natural', 97, 5.9, 4.9, 6.2, 'Gramas', 100, 29);
INSERT INTO public.ingredientes VALUES ('Iogurte natural desnatado', 38, 4.4, 4.6, 0.3, 'Gramas', 100, 30);
INSERT INTO public.ingredientes VALUES ('Kiwi', 42, 0.8, 10.1, 0.4, 'Unidade', 1, 31);
INSERT INTO public.ingredientes VALUES ('Laranja', 62, 1.2, 15.4, 0.2, 'Unidade', 1, 32);
INSERT INTO public.ingredientes VALUES ('Lentilha', 229, 18, 39.9, 0.8, 'Gramas', 100, 33);
INSERT INTO public.ingredientes VALUES ('Maca', 95, 0.5, 25.1, 0.3, 'Gramas', 100, 35);
INSERT INTO public.ingredientes VALUES ('Mamao', 39, 0.8, 9.9, 0.1, 'Gramas', 100, 38);
INSERT INTO public.ingredientes VALUES ('Manga', 86, 0.5, 22.5, 0.4, 'Gramas', 100, 39);
INSERT INTO public.ingredientes VALUES ('Fatia de Melancia', 30, 0.6, 7.6, 0.2, 'Gramas', 100, 40);
INSERT INTO public.ingredientes VALUES ('Morango', 49, 1, 11.7, 0.5, 'Gramas', 100, 41);
INSERT INTO public.ingredientes VALUES ('Mortadela', 319, 12, 2, 31, 'Gramas', 100, 42);
INSERT INTO public.ingredientes VALUES ('Ovo', 78, 6.3, 0.6, 5.3, 'Unidade', 1, 43);
INSERT INTO public.ingredientes VALUES ('Peito de frango', 165, 31, 0, 3.6, 'Gramas', 100, 44);
INSERT INTO public.ingredientes VALUES ('Peito de peru', 22, 2.7, 0, 1, 'Gramas', 100, 45);
INSERT INTO public.ingredientes VALUES ('Pepino', 45, 2.1, 9.3, 0.3, 'Unidade', 1, 46);
INSERT INTO public.ingredientes VALUES ('Pimenta-do-reino', 6, 0.2, 1.2, 0, 'A gosto', 1, 47);
INSERT INTO public.ingredientes VALUES ('Pimentao verde', 25, 1, 6, 0.3, 'Unidade', 1, 48);
INSERT INTO public.ingredientes VALUES ('Presunto', 46, 5.5, 1, 2.4, 'Gramas', 100, 49);
INSERT INTO public.ingredientes VALUES ('Queijo minas frescal', 240, 20, 2, 17, 'Gramas', 100, 50);
INSERT INTO public.ingredientes VALUES ('Queijo mussarela', 300, 22, 2, 24, 'Gramas', 100, 51);
INSERT INTO public.ingredientes VALUES ('Queijo parmesao', 431, 38, 1, 29, 'Gramas', 100, 52);
INSERT INTO public.ingredientes VALUES ('Quiabo', 33, 2, 7.6, 0.2, 'Gramas', 100, 53);
INSERT INTO public.ingredientes VALUES ('Salmao', 206, 22, 0, 13, 'Gramas', 100, 55);
INSERT INTO public.ingredientes VALUES ('Salsicha de frango', 189, 16, 3, 13, 'Gramas', 100, 56);
INSERT INTO public.ingredientes VALUES ('Tofu', 76, 8, 1.5, 4.8, 'Gramas', 100, 57);
INSERT INTO public.ingredientes VALUES ('Uva', 69, 0.7, 18.1, 0.2, 'Gramas', 100, 60);
INSERT INTO public.ingredientes VALUES ('Farinha de Trigo', 455, 12, 95, 1.4, 'Xicara', 1, 63);
INSERT INTO public.ingredientes VALUES ('Fermento em Po', 12, 0, 0.94, 0, 'Unidade', 1, 64);
INSERT INTO public.ingredientes VALUES ('Pimentao Vermelho', 31, 1.18, 7.18, 0.36, 'Unidade', 1, 65);
INSERT INTO public.ingredientes VALUES ('Salsinha', 35, 2.91, 6.21, 0.77, 'A gosto', 1, 67);
INSERT INTO public.ingredientes VALUES ('Polvilho Doce', 349, 0.3, 86.82, 0.2, 'Gramas', 100, 68);
INSERT INTO public.ingredientes VALUES ('Leite de Vaca', 61, 3.2, 4.8, 3.2, 'ML', 100, 69);
INSERT INTO public.ingredientes VALUES ('Cacau em Po', 229, 19.6, 54.3, 13.7, 'Gramas', 100, 70);
INSERT INTO public.ingredientes VALUES ('Bicarbonato de Sodio', 0, 0, 0, 0, 'CS', 1, 71);
INSERT INTO public.ingredientes VALUES ('Essencia de Baunilha', 12, 0, 0.53, 0, 'A gosto', 1, 72);
INSERT INTO public.ingredientes VALUES ('Agua', 0, 0, 0, 0, 'ML', 100, 73);
INSERT INTO public.ingredientes VALUES ('Milho', 96, 3.3, 18.7, 1.2, 'Unidade', 1, 74);
INSERT INTO public.ingredientes VALUES ('Ervilha', 117, 7.86, 20, 0.58, 'Gramas', 100, 75);
INSERT INTO public.ingredientes VALUES ('Farinha de Rosca', 343, 13, 69, 0, 'Gramas', 100, 77);
INSERT INTO public.ingredientes VALUES ('Leite Condensado', 194, 2.6, 40, 2, 'ML', 100, 78);
INSERT INTO public.ingredientes VALUES ('Creme de Leite', 135, 0, 3.5, 13, 'ML', 100, 79);
INSERT INTO public.ingredientes VALUES ('Manteiga', 683, 0.79, 0.6, 76.7, 'Gramas', 100, 80);
INSERT INTO public.ingredientes VALUES ('Ricota', 130, 15, 2, 7, 'Gramas', 100, 81);
INSERT INTO public.ingredientes VALUES ('Manjericao', 1, 0.13, 0.23, 0.03, 'A gosto', 1, 82);
INSERT INTO public.ingredientes VALUES ('Leite de Coco', 230, 2.3, 2.8, 24, 'ML', 100, 84);
INSERT INTO public.ingredientes VALUES ('Caldo de Galinha', 24, 0, 1.4, 1.8, 'Unidade', 1, 85);
INSERT INTO public.ingredientes VALUES ('Vinho Branco', 81, 0, 2.54, 0, 'ML', 100, 88);
INSERT INTO public.ingredientes VALUES ('Peixe', 84, 17.76, 0, 0.92, 'Gramas', 100, 89);
INSERT INTO public.ingredientes VALUES ('Limao Siciliano', 17, 0.6, 5.4, 0.2, 'Unidade', 1, 90);
INSERT INTO public.ingredientes VALUES ('Massa de Lasanha', 142, 4, 27, 2, 'Gramas', 100, 91);
INSERT INTO public.ingredientes VALUES ('Feijao', 200, 14, 32, 0, 'Gramas', 100, 92);
INSERT INTO public.ingredientes VALUES ('Bacon', 123, 5, 0, 11.31, 'Gramas', 100, 93);
INSERT INTO public.ingredientes VALUES ('Linguica', 1170, 60, 0, 100, 'Gramas', 100, 94);
INSERT INTO public.ingredientes VALUES ('Farinha de Mandioca', 390, 10.6, 80, 3, 'Gramas', 100, 95);
INSERT INTO public.ingredientes VALUES ('Camarao', 86, 16.2, 0, 1.2, 'Gramas', 100, 96);
INSERT INTO public.ingredientes VALUES ('Ervas finas', 0, 0, 0, 0, 'A gosto', 1, 97);
INSERT INTO public.ingredientes VALUES ('Chuchu', 19, 1.2, 3.6, 0.2, 'Unidade', 1, 98);
INSERT INTO public.ingredientes VALUES ('Quinoa', 374, 13.1, 68.9, 5.8, 'Gramas', 100, 99);
INSERT INTO public.ingredientes VALUES ('Bolacha Maisena', 544, 7.7, 73.3, 14, 'Gramas', 100, 101);
INSERT INTO public.ingredientes VALUES ('Gema', 55, 2.7, 0.61, 4.51, 'Unidade', 1, 102);
INSERT INTO public.ingredientes VALUES ('Tomate', 25, 1.1, 5.5, 0.3, 'Unidade', 1, 58);
INSERT INTO public.ingredientes VALUES ('Abacate', 332, 4, 17, 29, 'Unidade', 1, 1);
INSERT INTO public.ingredientes VALUES ('Arroz integral', 222, 5.2, 46.4, 1.8, 'Xícara', 1, 10);
INSERT INTO public.ingredientes VALUES ('Banana', 105, 1.3, 27, 0.4, 'Unidade', 1, 12);
INSERT INTO public.ingredientes VALUES ('Berinjela', 42, 1.8, 9.5, 0.4, 'Unidade', 1, 15);
INSERT INTO public.ingredientes VALUES ('Brocolis', 31, 2.6, 6, 0.5, 'Unidade', 1, 16);
INSERT INTO public.ingredientes VALUES ('Cebola', 44, 1.1, 10, 0.1, 'Unidade', 1, 18);
INSERT INTO public.ingredientes VALUES ('Cebola roxa', 20, 0.5, 4.5, 0.1, 'Unidade', 1, 19);
INSERT INTO public.ingredientes VALUES ('Couve-flor', 104, 8.2, 20, 1.2, 'Unidade', 1, 24);
INSERT INTO public.ingredientes VALUES ('Chocolate Meio Amargo', 496, 6.4, 52, 28.4, 'Gramas', 100, 103);
INSERT INTO public.ingredientes VALUES ('Nozes', 700, 10, 14, 70, 'Gramas', 100, 104);
INSERT INTO public.ingredientes VALUES ('Coco Ralado', 354, 3.3, 23.7, 33.5, 'Gramas', 100, 105);
INSERT INTO public.ingredientes VALUES ('Vinho Tinto', 83, 0, 2.56, 0, 'ML', 100, 106);
INSERT INTO public.ingredientes VALUES ('Gordura Vegetal', 900, 0, 0, 100, 'Gramas', 100, 107);
INSERT INTO public.ingredientes VALUES ('Fettuccini', 99, 6, 14, 3.6, 'Gramas', 100, 108);
INSERT INTO public.ingredientes VALUES ('Creme de Leite Fresco', 292, 2.8, 2.7, 30.6, 'ML', 100, 109);
INSERT INTO public.ingredientes VALUES ('Sal', 0, 0, 0, 0, 'A gosto', 1, 54);
INSERT INTO public.ingredientes VALUES ('Curry em Po', 0, 0.5, 2, 0.5, 'A gosto', 1, 83);
INSERT INTO public.ingredientes VALUES ('Batata-doce', 114, 2, 27, 0.1, 'Unidade', 1, 13);
INSERT INTO public.ingredientes VALUES ('Batata-inglesa', 129, 3, 29, 0, 'Unidade', 1, 14);
INSERT INTO public.ingredientes VALUES ('Abacaxi', 452, 4.5, 118, 2, 'Unidade', 1, 2);
INSERT INTO public.ingredientes VALUES ('Cenoura', 25, 0.6, 5.9, 0, 'Unidade', 1, 21);
INSERT INTO public.ingredientes VALUES ('Clara de ovo', 17, 3.6, 0.2, 0.1, 'Unidade', 1, 22);
INSERT INTO public.ingredientes VALUES ('Couve de Bruxelas', 43, 4.3, 6.8, 0.5, 'Unidade', 1, 23);
INSERT INTO public.ingredientes VALUES ('Dente de Alho', 4, 0.2, 1, 0, 'Unidade', 1, 7);
INSERT INTO public.ingredientes VALUES ('Caldo de Legumes', 32, 0, 2.4, 2.4, 'Unidade', 1, 86);
INSERT INTO public.ingredientes VALUES ('Arroz', 205, 4.3, 44.5, 0.3, 'Xicara', 1, 9);
INSERT INTO public.ingredientes VALUES ('Limao', 17, 0.7, 5.4, 0.3, 'Unidade', 1, 34);
INSERT INTO public.ingredientes VALUES ('Cogumelo', 22, 3.1, 3.3, 0.24, 'Gramas', 100, 87);
INSERT INTO public.ingredientes VALUES ('Molho de Tomate', 64, 1.6, 12.5, 0.5, 'Gramas', 100, 66);
INSERT INTO public.ingredientes VALUES ('Vinagre de Maçã', 22, 0, 0.9, 0, 'ML', 100, 100);
INSERT INTO public.ingredientes VALUES ('Açúcar', 774, 0, 200, 0, 'Xícara', 1, 62);
INSERT INTO public.ingredientes VALUES ('Requeijao', 320, 12, 4, 40, 'Gramas', 120, 76);
INSERT INTO public.ingredientes VALUES ('Gengibre', 4, 0.1, 1, 0.03, 'Unidade', 1, 26);
INSERT INTO public.ingredientes VALUES ('Batata-palha', 548, 5.2, 44, 39.6, 'Gramas', 100, 110);
INSERT INTO public.ingredientes VALUES ('Palmito', 115, 2.7, 26, 0.2, 'Gramas', 100, 111);
INSERT INTO public.ingredientes VALUES ('Farinha de Arroz', 732, 12, 160, 2.8, 'Xícara', 1, 112);
INSERT INTO public.ingredientes VALUES ('Milho de Pipoca', 312, 10.8, 68, 0, 'Gramas', 100, 113);
INSERT INTO public.ingredientes VALUES ('Óleo de Soja', 884, 0, 0, 100, 'ML', 100, 61);
INSERT INTO public.ingredientes VALUES ('Canela', 0, 0, 0, 0, 'A gosto', 1, 114);
INSERT INTO public.ingredientes VALUES ('Macarrão', 157, 5.76, 30.68, 0.92, 'Gramas', 100, 36);
INSERT INTO public.ingredientes VALUES ('Macarrão integral', 371, 14.5, 73, 2.2, 'Gramas', 100, 37);


--
-- TOC entry 4837 (class 0 OID 16477)
-- Dependencies: 218
-- Data for Name: pastas; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.pastas VALUES ('favoritos', 1, true, 1);
INSERT INTO public.pastas VALUES ('favoritas', 2, true, 7);


--
-- TOC entry 4838 (class 0 OID 16482)
-- Dependencies: 219
-- Data for Name: pastas_receitas; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.pastas_receitas VALUES (1, 1);


--
-- TOC entry 4839 (class 0 OID 16485)
-- Dependencies: 220
-- Data for Name: receitas; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.receitas VALUES ('Fettuccine Alfredo', 'Cozinhe 400g de fettuccine em água salgada até ficar al dente.
Em uma panela, aqueça 200ml de creme de leite fresco e adicione 100g de queijo parmesão ralado.
Quando o queijo estiver derretido, adicione a massa e misture.
Sirva imediatamente.', 25, 1583, 59.6, 114.4, 98.2, 'https://i.postimg.cc/PJzR4SFJ/Any-Conv-com-Fettuccine-Alfredo-Guia-da-semana-1.jpg', true, true, true, false, true, 1);
INSERT INTO public.receitas VALUES ('Fricassê de Frango', 'Bata no liquidificador o requeijão, o creme de leite e a água.
Refogue o creme do liquidificador com o frango desfiado e o sal até ficar com uma textura espessa.
Coloque o refogado numa assadeira, cubra com mussarela e espalhe a batata palha por cima.
Leve ao forno até borbulhar.
Sirva com arroz branco.', 30, 3076.3333, 255.2, 65.166664, 214.86667, 'https://i.postimg.cc/7hdqXr1N/Screenshot-6.png', false, true, false, false, true, 2);
INSERT INTO public.receitas VALUES ('Pipoca Doce', 'Em uma panela, adicione todos os ingredientes e misture delicadamente.
Desligue o fogo quando o intervalo de tempo entre os estouros da pipoca diminuir.', 20, 1369.05, 13.32, 158.945, 80.055, 'https://i.postimg.cc/vm2g1MYH/pipoca-de-brigadeiro.png', false, false, true, true, false, 4);
INSERT INTO public.receitas VALUES ('Omelete de Espinafre e Queijo', 'Bata ovos em uma tigela e adicione espinafre picado e queijo mussarela ralado.
Despeje a mistura em uma frigideira quente e cozinhe até dourar dos dois lados.
Sirva quente.', 15, 460.6, 35.18, 3.92, 34.68, 'https://i.postimg.cc/GmQsCG6D/omelete-de-espinafre-2.jpg', true, true, true, false, true, 3);
INSERT INTO public.receitas VALUES ('Brigadeiro de colher', 'Em uma panela, coloque o leite condensado, a manteiga e o chocolate em pó.
Leve ao fogo baixo, mexendo sempre, até desgrudar do fundo da panela (cerca de 10 minutos).
Desligue o fogo e deixe esfriar.
Faça bolinhas com a massa e passe no granulado.
Sirva em colheres individuais.', 20, 913.45, 27.5185, 174.39, 31.205002, 'https://i.postimg.cc/YqF9pYL9/brigadeiro-de-colher.jpg', false, true, true, true, false, 25);
INSERT INTO public.receitas VALUES ('Arroz Doce', 'Cozinhe o arroz no leite, juntamente com a canela (utilize uma panela grande para que o leite ferva e não derrame).
Após 20 minutos, mexa de tempos em tempos.
Acrescente o açúcar e deixe por 20 minutos.
Logo em seguida, acrescente o leite condensado e deixe por mais 20 minutos.
Coloque em uma travessa e sirva.', 60, 4229, 64.4, 881, 54.6, 'https://i.postimg.cc/sxQ2GZnT/arroz-doce-cremoso-simples-312-orig.jpg', false, true, true, true, false, 5);
INSERT INTO public.receitas VALUES ('Carbonara', 'Cozinhe 400g de spaghetti em água salgada até ficar al dente.
Em uma frigideira, doure 100g de bacon picado.
Bata 2 ovos com 50g de queijo parmesão ralado e 50g de queijo pecorino ralado.
Escorra a massa e misture-a com o bacon e a mistura de ovos.', 20, 1122.5, 59.64, 124.42, 40.09, 'https://i.postimg.cc/SRpPCBdH/Any-Conv-com-macarrao-a-carbonara-receita.jpg', true, true, false, false, true, 6);
INSERT INTO public.receitas VALUES ('Macarrão a Bolonhesa', 'Pique a cebola, refogue por alguns minutos em uma panela com óleo quente até dourar a cebola, mexendo para não queimar.
Misture a carne moída, deixe cozinhar por alguns minutos.
Adicione o caldo, o molho, os tomates picados, a cenoura cortada ao meio e mexa bem, deixe cozinhar por aproximadamente 40minutos em fogo baixo com a panela semi tampada. Descarte a cenoura depois que o molho estiver pronto.
Prepare o macarrão, misture o molho ao macarrão e sirva.
Acompanhamento Sugerido: Queijo Ralado', 45, 2594, 167.3, 257.69998, 98.5, 'https://i.postimg.cc/PxNX0wkd/galo-imagem-receitas-macarrao-a-bolonhesa-share.jpg', true, false, false, false, true, 7);
INSERT INTO public.receitas VALUES ('Bolo de cenoura', 'Misture os ovos, o óleo e o açúcar em um recipiente.
Em seguida, adicione as cenouras raladas e misture bem.
Bata tudo em um liquidificador.
Adicione a farinha de trigo e misture novamente até ficar homogêneo.
Por último, adicione o fermento em pó e misture delicadamente.
Despeje a massa em uma forma untada e enfarinhada e leve ao forno preaquecido a 180°C por cerca de 35 minutos.
SUGESTÃO: Brigadeiro por cima', 45, 4067.3, 50.7, 657.94, 139.40001, 'https://i.postimg.cc/NMXVys61/Any-Conv-com-bolo-de-cenoura-com-ganache1.jpg', true, false, true, true, true, 8);
INSERT INTO public.receitas VALUES ('Arroz carreteiro', 'Cozinhe a carne em uma panela de pressão por cerca de 30 minutos.
Em outra panela, refogue a cebola, o alho e o pimentão no óleo.
Adicione o tomate e deixe cozinhar por alguns minutos.
Adicione a carne desfiada e o arroz, misture bem e acrescente água suficiente para cobrir tudo.
Tempere com sal e pimenta-do-reino a gosto e deixe cozinhar em fogo baixo até que o arroz esteja cozido.
Adicione o cheiro-verde picado e sirva.', 70, 2223.8, 141.19, 124.59, 132.43001, 'https://i.postimg.cc/qRZR7GGt/Arroz-de-carreteiro-na-pressao-e1666637244170.jpg', false, false, false, false, true, 9);
INSERT INTO public.receitas VALUES ('Pão de queijo', 'Em uma panela, aqueca o leite com o oleo e o sal ate ferver.
Coloque o polvilho em uma tigela e despeje a mistura quente por cima, mexendo com uma colher de pau.
Adicione os ovos um a um, misturando bem a cada adicao.
Acrescente o queijo ralado e misture novamente.
Faca bolinhas com a massa e coloque em uma assadeira untada.
Leve ao forno preaquecido a 180C por cerca de 25 minutos ou ate que os paes de queijo estejam dourados..', 35, 2588.4502, 64.432, 439.948, 65.932, 'https://i.postimg.cc/CMBDqZfy/Pao-de-queijo-Essa-Receita-Funciona-9.jpg', false, true, true, false, true, 10);
INSERT INTO public.receitas VALUES ('Bolo de Chocolate', 'Pre-aqueca o forno a 180C.
Em uma tigela grande, misture o acucar, a farinha de trigo, o cacau em po, o bicarbonato de sodio e o sal.
Adicione os ovos, o leite, o oleo e a essencia de baunilha e misture ate ficar homogeneo.
Acrescente a agua quente e misture novamente.
Despeje a massa em uma forma untada e enfarinhada.
Asse por cerca de 30 a 35 minutos ou ate que um palito inserido no centro do bolo saia limpo.
Deixe esfriar antes de servir.', 45, 2129.81, 23.732, 513.083, 16.357, 'https://i.postimg.cc/W1P4tz07/C-pia-de-Bolo-Tradicional-de-Chocolate-sem-calda-1.jpg', true, true, true, true, false, 11);
INSERT INTO public.receitas VALUES ('Arroz de Forno', 'Refogue a cebola e o alho na manteiga até dourar.
Adicione o arroz e refogue por alguns minutos.
Adicione a água, o sal e a pimenta.
Misture bem e deixe cozinhar até que a água evapore.
Misture as ervilhas, o milho, a cenoura e o queijo ralado ao arroz e coloque em um refratário.
Leve ao forno pré-aquecido a 180 graus por cerca de 20 minutos.
Tempere os filés de frango com sal e pimenta.
Passe os filés de frango na farinha de trigo, nos ovos batidos e na farinha de rosca.
Frite em óleo quente até que estejam dourados.
Em um refratário, coloque os filés fritos, o molho de tomate, a mussarela e o parmesão ralados.
Leve ao forno pré-aquecido a 180 graus por cerca de 20 minutos.', 50, 2037.9, 66.151596, 46.377003, 182.7488, 'https://i.postimg.cc/q7JMXFbh/arroz-de-forno-com-frango-e-legumes-1578483497914-v2-1x1.jpg', false, true, true, false, true, 12);
INSERT INTO public.receitas VALUES ('Frango à Parmegiana', 'Tempere os filés de frango com sal e pimenta.
Passe os filés na farinha de trigo, nos ovos batidos e na farinha de rosca.
Frite em óleo quente até que estejam dourados.
Em um refratário, coloque os filés fritos, o molho de tomate, a mussarela e o parmesão ralados.
Leve ao forno pré-aquecido a 180 graus por cerca de 20 minutos.', 60, 642.05005, 27.152, 99.079994, 12.924, 'https://i.postimg.cc/Xv9dpqHK/parmeg.png', true, true, false, false, true, 13);
INSERT INTO public.receitas VALUES ('Brigadeirão', 'Bata todos os ingredientes no liquidificador até que fique uma mistura homogênea.
Despeje a mistura em uma forma untada com manteiga.
Leve ao forno pré-aquecido a 180 graus por cerca de 45 minutos.
Deixe esfriar antes de desenformar.', 60, 324.41, 25.4299, 3.384, 22.254, 'https://i.postimg.cc/44qykBdq/bolo-brigadeirao-dani-noce-receita-nestle-moca-imagem-destaque.jpg', false, true, true, true, false, 14);
INSERT INTO public.receitas VALUES ('Lasanha de abobrinha ', 'Preaqueça o forno a 180°C.
Em uma tigela, misture a ricota, o manjericão fresco picado e sal e pimenta a gosto.
Em um refratário, espalhe um pouco de molho de tomate no fundo e cubra com uma camada de fatias de abobrinha.
Adicione uma camada da mistura de ricota e cubra com outra camada de abobrinha. Repita o processo até que todos os ingredientes tenham sido usados.
Cubra a lasanha com o restante do molho de tomate e polvilhe com os queijos mussarela e parmesão.
Regue com azeite de oliva e cubra com papel alumínio.
Asse no forno por cerca de 30 minutos, retire o papel alumínio e asse por mais 10 minutos ou até que o queijo esteja dourado e borbulhante.', 60, 32.170002, 2.348, 1.336, 1.836, 'https://i.postimg.cc/1X3qCH9M/lasanha-abo.png', false, true, true, false, true, 15);
INSERT INTO public.receitas VALUES ('Cocada de leite condensado', 'Em uma panela, misture o leite condensado, o coco ralado e o açúcar.
Leve ao fogo médio e mexa constantemente até que a mistura comece a desgrudar do fundo da panela.
Despeje a mistura em uma forma untada com manteiga e deixe esfriar.
Corte em pedaços e sirva.', 40, 2161, 15.699999, 387.4, 74, 'https://i.postimg.cc/vZLZnyzw/Cocada.jpg', true, true, true, true, false, 30);
INSERT INTO public.receitas VALUES ('Frango ao curry com leite de coco', 'Em uma panela, aqueça o azeite de oliva em fogo médio-alto.
Adicione a cebola e refogue até que fique macia, cerca de 3-5 minutos.
Adicione o alho e o curry em pó e cozinhe por mais 1-2 minutos.
Adicione o frango e cozinhe até dourar, cerca de 5 minutos.
Adicione o leite de coco, o caldo de galinha, o pimentão vermelho e a cenoura. Misture bem.
Tempere com sal e pimenta a gosto.
Deixe a mistura ferver e depois reduza o fogo para médio-baixo. Cozinhe por cerca de 20 minutos ou até que o frango esteja cozido e os legumes estejam macios.
Sirva com arroz branco.', 40, 1606, 195.18, 37.58, 73.560005, 'https://i.postimg.cc/QN27kXpF/receitas-de-frango-ao-curry-3.jpg', false, false, false, false, true, 16);
INSERT INTO public.receitas VALUES ('Risoto de cogumelos', 'Em uma panela, aqueça o caldo de legumes e mantenha em fogo baixo.
Em outra panela, derreta 1 colher de manteiga em fogo médio e refogue a cebola e o alho até ficarem macios.
Adicione o arroz e misture bem com a manteiga e os temperos.
Junte o vinho branco e deixe cozinhar até que seja absorvido pelo arroz.
Adicione uma concha do caldo quente na panela do arroz e mexa até ser completamente absorvido.
Continue adicionando conchas de caldo quente, uma de cada vez, até que o arroz esteja cozido.
Em uma frigideira, aqueça a outra colher de manteiga e refogue os cogumelos por cerca de 5 minutos.
Adicione os cogumelos ao risoto e misture.
Finalize com queijo parmesão ralado, sal e pimenta a gosto.', 50, 1671.15, 106.687004, 72.435005, 97.47, 'https://i.postimg.cc/YqQWdJ3b/risoto-cog.jpg', false, true, true, false, true, 17);
INSERT INTO public.receitas VALUES ('Peixe assado com batatas', 'Preaqueça o forno a 200°C.
Tempere os filés de peixe com sal, pimenta e suco de limão.
Em uma tigela, misture as batatas fatiadas, a cebola roxa, o alho, o azeite e as ervas finas.
Espalhe a mistura de batatas em uma assadeira e coloque os filés de peixe por cima.
Cubra com papel alumínio e leve ao forno por cerca de 30 minutos.
Retire o papel alumínio e deixe assar por mais 10 minutos ou até que as batatas estejam douradas e o peixe esteja cozido.', 60, 1227, 139.32, 137.59999, 11.040001, 'https://i.postimg.cc/w3Y9t4RB/Peixe-assado-suculento.jpg', false, false, false, false, true, 18);
INSERT INTO public.receitas VALUES ('Sopa de legumes', 'Descasque e corte os legumes em cubos.
Em uma panela, aqueça o azeite e refogue a cebola e o alho até dourar.
Adicione os legumes e refogue por alguns minutos.
Adicione a água, o cubo de caldo de legumes, sal e pimenta.
Cozinhe por cerca de 20 minutos ou até que os legumes estejam macios.
Bata a sopa no liquidificador ou com um mixer de mão.
Volte a sopa para a panela e aqueça novamente antes de servir.', 30, 359.21, 8.764, 72.133, 4.953, 'https://i.postimg.cc/9FbkwN7N/Any-Conv-com-sopa-leg.jpg', false, false, true, false, true, 19);
INSERT INTO public.receitas VALUES ('Strogonoff de frango', 'Em uma panela, derreta a manteiga e refogue a cebola e o alho até dourar.
Adicione o frango e deixe cozinhar até dourar.
Acrescente o ketchup, a água, o sal e a pimenta e deixe cozinhar por cerca de 10 minutos.
Por último, adicione o creme de leite e mexa bem até aquecer. Sirva com arroz branco e batata palha.', 30, 1594.45, 162.2185, 64.28999, 70.104996, 'https://i.postimg.cc/3wVVJ4v8/Any-Conv-com-Strogonoff-de-Frango-Tradicional.jpg', true, false, false, false, true, 20);
INSERT INTO public.receitas VALUES ('Lasanha de carne moída', 'Em uma panela, refogue a cebola e o alho no óleo até dourar.
Adicione a carne moída e deixe cozinhar até dourar.
Acrescente o molho de tomate, a água, o sal e a pimenta e deixe cozinhar por cerca de 10 minutos.
Em um refratário, faça camadas de massa, carne e queijo ralado, terminando com o queijo ralado.
Leve ao forno preaquecido a 180°C por cerca de 30 minutos ou até que o queijo esteja derretido e dourado.', 60, 3254.6, 218.09999, 194.7, 183.6, 'https://i.postimg.cc/gjZY2bJ5/lasanha-de-carne-moida-2.jpg', true, true, false, false, true, 21);
INSERT INTO public.receitas VALUES ('Feijão tropeiro ', 'Em uma frigideira grande, frite o bacon até que esteja crocante.
Adicione a linguiça calabresa e frite até que esteja dourada.
Adicione a cebola, o alho e os pimentões e refogue até que a cebola esteja macia.
Adicione o feijão carioca cozido e tempere com sal e pimenta-do-reino a gosto. Deixe cozinhar por alguns minutos.
Adicione a farinha de mandioca e misture bem até que fique bem incorporada.
Por último, adicione o cheiro-verde picado e misture novamente.
Sirva quente acompanhado de arroz branco.', 40, 6357, 312.33002, 488.03, 337.43, 'https://i.postimg.cc/hjwDntST/Feijao-Tropeiro-1.jpg', false, false, false, false, true, 22);
INSERT INTO public.receitas VALUES ('Risoto de limão siciliano com camarão', 'Aqueça o caldo de legumes em uma panela à parte.
Em outra panela, refogue a cebola e o alho na manteiga e no azeite até ficarem macios.
Adicione o arroz arbóreo e mexa por 2 minutos.
Acrescente o vinho branco e mexa até evaporar.
Adicione o caldo de legumes, concha por concha, mexendo sempre até o arroz ficar cremoso e al dente.
Enquanto isso, tempere os camarões com sal, pimenta e suco de limão.
Em outra panela, grelhe os camarões no azeite até ficarem cozidos e reserve.
Adicione as raspas de limão e a salsinha ao risoto e misture bem.
Sirva o risoto com os camarões grelhados por cima.', 45, 1299.65, 95.847, 122.295006, 37.28, 'https://i.postimg.cc/Sx2WbDcv/risoto-limao-cam.png', false, true, false, false, true, 23);
INSERT INTO public.receitas VALUES ('Salada de quinoa com frango e legumes', 'Em uma tigela grande, misture a quinoa, o frango desfiado, a cenoura, a abobrinha, o pimentão, a cebola e a salsinha.
Em outra tigela, misture o azeite, o vinagre, o suco de limão, o sal e a pimenta até formar um molho homogêneo.
Despeje o molho sobre a salada e misture bem.
Sirva a salada fria.', 30, 2378.71, 163.14401, 331.088, 51.213, 'https://i.postimg.cc/xCYHHQhw/quinoa.png', false, false, false, false, true, 24);
INSERT INTO public.receitas VALUES ('Pudim de leite condensado', 'Preaqueça o forno a 180°C.
Em uma forma de pudim, derreta o açúcar em fogo baixo, mexendo sempre, até formar uma calda.
Bata no liquidificador o leite condensado, o leite e os ovos.
Despeje a mistura na forma de pudim, sobre a calda.
Cubra a forma com papel alumínio e leve ao forno em banho-maria por cerca de 1 hora.
Retire o papel alumínio e deixe no forno por mais 10 minutos, para dourar a superfície.
Deixe esfriar e leve à geladeira por pelo menos 2 horas antes de servir.', 180, 1896.3, 35.57, 369.40002, 30.2, 'https://i.postimg.cc/YCkmZbDk/pudim-de-leite-condensado-1682011837513-v2-4x3.jpg', false, true, true, true, false, 26);
INSERT INTO public.receitas VALUES ('Torta de limão', 'Triture a bolacha maisena até formar uma farofa e misture com a manteiga derretida.
Forre uma forma com a massa de bolacha e reserve.
Em uma tigela, misture o leite condensado, o suco de limão e as gemas até obter um creme homogêneo.
Despeje o creme sobre a massa de bolacha e leve a torta à geladeira por cerca de 2 horas.
Decore com raspas de limão antes de servir.', 30, 1883.4, 23.41, 212.80002, 102.619995, 'https://i.postimg.cc/yN83YWzb/torta-de-limao.jpg', true, true, true, true, false, 27);
INSERT INTO public.receitas VALUES ('Brownie de chocolate com nozes', 'Em uma panela, derreta o chocolate meio amargo com a manteiga em fogo baixo.
Adicione o açúcar e mexa até incorporar.
Junte os ovos, um a um, mexendo bem após cada adição.
Adicione a farinha de trigo e as nozes picadas, misturando bem.
Despeje a massa em uma forma untada e enfarinhada.
Asse em forno preaquecido a 180°C por cerca de 25 minutos.
Deixe esfriar antes de cortar em pedaços e servir.', 40, 4686.25, 63.2925, 706.05, 182.02501, 'https://i.postimg.cc/T1z3VYFf/bangor-brownies.jpg', true, true, true, true, false, 28);
INSERT INTO public.receitas VALUES ('Brigadeiro de morango', 'Em uma panela, misture o leite condensado, o creme de leite e a manteiga.
Leve ao fogo baixo, mexendo sempre, até desgrudar do fundo da panela.
Adicione os morangos picados e misture bem.
Despeje a mistura em um recipiente untado com manteiga e deixe esfriar.
Faça bolinhas e passe no granulado rosa para decorar.', 30, 1284.45, 11.218499, 173.98999, 58.505, 'https://i.postimg.cc/15YpdLVF/brig-morango.png', true, true, true, true, false, 29);
INSERT INTO public.receitas VALUES ('Arroz com frango e legumes', 'Em uma panela, refogue a cebola e o alho até dourar.
Adicione o frango desfiado e refogue até que esteja dourado.
Acrescente a cenoura e a abobrinha e refogue por mais alguns minutos.
Adicione o arroz e a água, tempere com sal e pimenta e deixe cozinhar em fogo baixo até que a água seja completamente absorvida e o arroz esteja cozido.', 60, 3002.7, 261.70004, 99.304, 170.70001, 'https://i.postimg.cc/KYRC2r4p/Any-Conv-com-arroz-com-frango-e-legumes.jpg', false, false, false, false, true, 31);
INSERT INTO public.receitas VALUES ('Quiche de Frango ', 'Preaqueça o forno a 200°C.
Em uma tigela grande, misture a farinha e o sal.
Adicione a manteiga e a gordura vegetal, e misture até obter uma mistura grossa e esfarelada.
Adicione a água gelada e misture até a massa ficar úmida.
Forme uma bola com a massa, cubra com plástico filme e leve à geladeira por 30 minutos.
Em uma tigela, misture o frango desfiado, o queijo mussarela, o creme de leite, o leite, os ovos, o sal e a pimenta-do-reino.
Abra a massa com um rolo e forre uma forma de quiche.
Fure o fundo da massa com um garfo e coloque o recheio por cima.
Leve ao forno por cerca de 40 minutos ou até que a quiche esteja dourada.
Retire do forno e sirva quente.', 70, 2585.95, 203.13748, 112.11, 143.315, 'https://i.postimg.cc/ZRcNxghC/quiche.png', true, true, false, false, true, 32);


--
-- TOC entry 4840 (class 0 OID 16494)
-- Dependencies: 221
-- Data for Name: receitas_ingredientes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.receitas_ingredientes VALUES (150, 4, 78);
INSERT INTO public.receitas_ingredientes VALUES (200, 1, 109);
INSERT INTO public.receitas_ingredientes VALUES (100, 1, 52);
INSERT INTO public.receitas_ingredientes VALUES (3, 10, 43);
INSERT INTO public.receitas_ingredientes VALUES (200, 10, 51);
INSERT INTO public.receitas_ingredientes VALUES (1, 10, 54);
INSERT INTO public.receitas_ingredientes VALUES (1, 10, 61);
INSERT INTO public.receitas_ingredientes VALUES (500, 10, 68);
INSERT INTO public.receitas_ingredientes VALUES (1, 10, 69);
INSERT INTO public.receitas_ingredientes VALUES (1, 11, 54);
INSERT INTO public.receitas_ingredientes VALUES (5, 11, 61);
INSERT INTO public.receitas_ingredientes VALUES (2, 11, 62);
INSERT INTO public.receitas_ingredientes VALUES (0.75, 11, 63);
INSERT INTO public.receitas_ingredientes VALUES (1, 11, 69);
INSERT INTO public.receitas_ingredientes VALUES (75, 11, 70);
INSERT INTO public.receitas_ingredientes VALUES (5, 11, 71);
INSERT INTO public.receitas_ingredientes VALUES (2, 11, 72);
INSERT INTO public.receitas_ingredientes VALUES (1, 11, 73);
INSERT INTO public.receitas_ingredientes VALUES (1, 12, 18);
INSERT INTO public.receitas_ingredientes VALUES (1, 12, 44);
INSERT INTO public.receitas_ingredientes VALUES (1, 12, 47);
INSERT INTO public.receitas_ingredientes VALUES (5, 12, 51);
INSERT INTO public.receitas_ingredientes VALUES (1, 12, 54);
INSERT INTO public.receitas_ingredientes VALUES (1, 12, 58);
INSERT INTO public.receitas_ingredientes VALUES (1, 12, 74);
INSERT INTO public.receitas_ingredientes VALUES (1, 12, 75);
INSERT INTO public.receitas_ingredientes VALUES (5, 12, 76);
INSERT INTO public.receitas_ingredientes VALUES (2, 12, 9);
INSERT INTO public.receitas_ingredientes VALUES (2, 13, 43);
INSERT INTO public.receitas_ingredientes VALUES (4, 13, 44);
INSERT INTO public.receitas_ingredientes VALUES (1, 13, 47);
INSERT INTO public.receitas_ingredientes VALUES (2, 13, 51);
INSERT INTO public.receitas_ingredientes VALUES (1, 13, 52);
INSERT INTO public.receitas_ingredientes VALUES (1, 13, 54);
INSERT INTO public.receitas_ingredientes VALUES (1, 13, 63);
INSERT INTO public.receitas_ingredientes VALUES (2, 13, 66);
INSERT INTO public.receitas_ingredientes VALUES (2, 13, 77);
INSERT INTO public.receitas_ingredientes VALUES (4, 14, 43);
INSERT INTO public.receitas_ingredientes VALUES (1, 14, 70);
INSERT INTO public.receitas_ingredientes VALUES (1, 14, 78);
INSERT INTO public.receitas_ingredientes VALUES (1, 14, 79);
INSERT INTO public.receitas_ingredientes VALUES (1, 14, 80);
INSERT INTO public.receitas_ingredientes VALUES (1, 15, 11);
INSERT INTO public.receitas_ingredientes VALUES (2, 15, 4);
INSERT INTO public.receitas_ingredientes VALUES (1, 15, 47);
INSERT INTO public.receitas_ingredientes VALUES (1, 15, 51);
INSERT INTO public.receitas_ingredientes VALUES (5, 15, 52);
INSERT INTO public.receitas_ingredientes VALUES (1, 15, 54);
INSERT INTO public.receitas_ingredientes VALUES (400, 1, 91);
INSERT INTO public.receitas_ingredientes VALUES (5, 12, 7);
INSERT INTO public.receitas_ingredientes VALUES (15, 16, 11);
INSERT INTO public.receitas_ingredientes VALUES (1, 16, 18);
INSERT INTO public.receitas_ingredientes VALUES (1, 16, 21);
INSERT INTO public.receitas_ingredientes VALUES (600, 16, 44);
INSERT INTO public.receitas_ingredientes VALUES (1, 16, 47);
INSERT INTO public.receitas_ingredientes VALUES (1, 16, 54);
INSERT INTO public.receitas_ingredientes VALUES (1, 16, 65);
INSERT INTO public.receitas_ingredientes VALUES (5, 16, 7);
INSERT INTO public.receitas_ingredientes VALUES (1, 16, 83);
INSERT INTO public.receitas_ingredientes VALUES (200, 16, 84);
INSERT INTO public.receitas_ingredientes VALUES (0.5, 16, 85);
INSERT INTO public.receitas_ingredientes VALUES (1, 17, 18);
INSERT INTO public.receitas_ingredientes VALUES (1, 17, 47);
INSERT INTO public.receitas_ingredientes VALUES (250, 17, 52);
INSERT INTO public.receitas_ingredientes VALUES (1, 17, 54);
INSERT INTO public.receitas_ingredientes VALUES (6, 17, 7);
INSERT INTO public.receitas_ingredientes VALUES (30, 17, 80);
INSERT INTO public.receitas_ingredientes VALUES (0.5, 17, 86);
INSERT INTO public.receitas_ingredientes VALUES (150, 17, 87);
INSERT INTO public.receitas_ingredientes VALUES (75, 17, 88);
INSERT INTO public.receitas_ingredientes VALUES (1, 17, 9);
INSERT INTO public.receitas_ingredientes VALUES (30, 18, 11);
INSERT INTO public.receitas_ingredientes VALUES (4, 18, 14);
INSERT INTO public.receitas_ingredientes VALUES (1, 18, 18);
INSERT INTO public.receitas_ingredientes VALUES (1, 18, 34);
INSERT INTO public.receitas_ingredientes VALUES (1, 18, 47);
INSERT INTO public.receitas_ingredientes VALUES (1, 18, 54);
INSERT INTO public.receitas_ingredientes VALUES (5, 18, 7);
INSERT INTO public.receitas_ingredientes VALUES (700, 18, 89);
INSERT INTO public.receitas_ingredientes VALUES (1, 18, 97);
INSERT INTO public.receitas_ingredientes VALUES (15, 19, 11);
INSERT INTO public.receitas_ingredientes VALUES (1, 19, 14);
INSERT INTO public.receitas_ingredientes VALUES (2.5, 19, 18);
INSERT INTO public.receitas_ingredientes VALUES (1, 19, 21);
INSERT INTO public.receitas_ingredientes VALUES (1, 19, 4);
INSERT INTO public.receitas_ingredientes VALUES (1, 19, 47);
INSERT INTO public.receitas_ingredientes VALUES (1, 19, 54);
INSERT INTO public.receitas_ingredientes VALUES (5, 19, 7);
INSERT INTO public.receitas_ingredientes VALUES (240, 19, 73);
INSERT INTO public.receitas_ingredientes VALUES (1, 19, 86);
INSERT INTO public.receitas_ingredientes VALUES (1, 19, 98);
INSERT INTO public.receitas_ingredientes VALUES (1, 20, 18);
INSERT INTO public.receitas_ingredientes VALUES (500, 20, 44);
INSERT INTO public.receitas_ingredientes VALUES (1, 20, 47);
INSERT INTO public.receitas_ingredientes VALUES (1, 20, 54);
INSERT INTO public.receitas_ingredientes VALUES (300, 20, 66);
INSERT INTO public.receitas_ingredientes VALUES (5, 20, 7);
INSERT INTO public.receitas_ingredientes VALUES (240, 20, 73);
INSERT INTO public.receitas_ingredientes VALUES (300, 20, 79);
INSERT INTO public.receitas_ingredientes VALUES (15, 20, 80);
INSERT INTO public.receitas_ingredientes VALUES (500, 21, 17);
INSERT INTO public.receitas_ingredientes VALUES (1, 21, 18);
INSERT INTO public.receitas_ingredientes VALUES (1, 21, 47);
INSERT INTO public.receitas_ingredientes VALUES (300, 21, 51);
INSERT INTO public.receitas_ingredientes VALUES (1, 21, 54);
INSERT INTO public.receitas_ingredientes VALUES (15, 21, 61);
INSERT INTO public.receitas_ingredientes VALUES (300, 21, 66);
INSERT INTO public.receitas_ingredientes VALUES (5, 21, 7);
INSERT INTO public.receitas_ingredientes VALUES (240, 21, 73);
INSERT INTO public.receitas_ingredientes VALUES (500, 21, 91);
INSERT INTO public.receitas_ingredientes VALUES (1, 22, 18);
INSERT INTO public.receitas_ingredientes VALUES (1, 22, 47);
INSERT INTO public.receitas_ingredientes VALUES (1, 22, 54);
INSERT INTO public.receitas_ingredientes VALUES (1, 22, 65);
INSERT INTO public.receitas_ingredientes VALUES (5, 22, 67);
INSERT INTO public.receitas_ingredientes VALUES (5, 22, 7);
INSERT INTO public.receitas_ingredientes VALUES (480, 22, 92);
INSERT INTO public.receitas_ingredientes VALUES (200, 22, 93);
INSERT INTO public.receitas_ingredientes VALUES (300, 22, 94);
INSERT INTO public.receitas_ingredientes VALUES (350, 22, 95);
INSERT INTO public.receitas_ingredientes VALUES (30, 23, 11);
INSERT INTO public.receitas_ingredientes VALUES (1, 23, 18);
INSERT INTO public.receitas_ingredientes VALUES (1, 23, 47);
INSERT INTO public.receitas_ingredientes VALUES (1, 23, 54);
INSERT INTO public.receitas_ingredientes VALUES (1, 23, 67);
INSERT INTO public.receitas_ingredientes VALUES (6, 23, 7);
INSERT INTO public.receitas_ingredientes VALUES (30, 23, 80);
INSERT INTO public.receitas_ingredientes VALUES (1, 23, 86);
INSERT INTO public.receitas_ingredientes VALUES (75, 23, 88);
INSERT INTO public.receitas_ingredientes VALUES (2, 23, 9);
INSERT INTO public.receitas_ingredientes VALUES (1, 23, 90);
INSERT INTO public.receitas_ingredientes VALUES (500, 23, 96);
INSERT INTO public.receitas_ingredientes VALUES (25, 24, 100);
INSERT INTO public.receitas_ingredientes VALUES (90, 24, 11);
INSERT INTO public.receitas_ingredientes VALUES (1, 24, 19);
INSERT INTO public.receitas_ingredientes VALUES (1, 24, 21);
INSERT INTO public.receitas_ingredientes VALUES (1, 24, 34);
INSERT INTO public.receitas_ingredientes VALUES (1, 24, 4);
INSERT INTO public.receitas_ingredientes VALUES (300, 24, 44);
INSERT INTO public.receitas_ingredientes VALUES (1, 24, 47);
INSERT INTO public.receitas_ingredientes VALUES (1, 24, 54);
INSERT INTO public.receitas_ingredientes VALUES (1, 24, 65);
INSERT INTO public.receitas_ingredientes VALUES (5, 24, 67);
INSERT INTO public.receitas_ingredientes VALUES (400, 24, 99);
INSERT INTO public.receitas_ingredientes VALUES (100, 25, 70);
INSERT INTO public.receitas_ingredientes VALUES (300, 25, 78);
INSERT INTO public.receitas_ingredientes VALUES (15, 25, 80);
INSERT INTO public.receitas_ingredientes VALUES (60, 27, 101);
INSERT INTO public.receitas_ingredientes VALUES (2, 27, 102);
INSERT INTO public.receitas_ingredientes VALUES (5, 27, 34);
INSERT INTO public.receitas_ingredientes VALUES (350, 27, 78);
INSERT INTO public.receitas_ingredientes VALUES (100, 27, 80);
INSERT INTO public.receitas_ingredientes VALUES (200, 29, 41);
INSERT INTO public.receitas_ingredientes VALUES (350, 29, 78);
INSERT INTO public.receitas_ingredientes VALUES (300, 29, 79);
INSERT INTO public.receitas_ingredientes VALUES (15, 29, 80);
INSERT INTO public.receitas_ingredientes VALUES (90, 31, 106);
INSERT INTO public.receitas_ingredientes VALUES (2, 31, 14);
INSERT INTO public.receitas_ingredientes VALUES (1000, 31, 17);
INSERT INTO public.receitas_ingredientes VALUES (1, 31, 18);
INSERT INTO public.receitas_ingredientes VALUES (2, 31, 21);
INSERT INTO public.receitas_ingredientes VALUES (1, 31, 47);
INSERT INTO public.receitas_ingredientes VALUES (1, 31, 54);
INSERT INTO public.receitas_ingredientes VALUES (2, 31, 58);
INSERT INTO public.receitas_ingredientes VALUES (5, 31, 7);
INSERT INTO public.receitas_ingredientes VALUES (240, 31, 73);
INSERT INTO public.receitas_ingredientes VALUES (3, 8, 21);
INSERT INTO public.receitas_ingredientes VALUES (3, 8, 43);
INSERT INTO public.receitas_ingredientes VALUES (120, 8, 61);
INSERT INTO public.receitas_ingredientes VALUES (2, 8, 62);
INSERT INTO public.receitas_ingredientes VALUES (2.5, 8, 63);
INSERT INTO public.receitas_ingredientes VALUES (1, 8, 64);
INSERT INTO public.receitas_ingredientes VALUES (500, 9, 17);
INSERT INTO public.receitas_ingredientes VALUES (1, 9, 18);
INSERT INTO public.receitas_ingredientes VALUES (1, 9, 47);
INSERT INTO public.receitas_ingredientes VALUES (1, 9, 54);
INSERT INTO public.receitas_ingredientes VALUES (2, 9, 58);
INSERT INTO public.receitas_ingredientes VALUES (45, 9, 61);
INSERT INTO public.receitas_ingredientes VALUES (1, 9, 65);
INSERT INTO public.receitas_ingredientes VALUES (1, 9, 67);
INSERT INTO public.receitas_ingredientes VALUES (2, 9, 9);
INSERT INTO public.receitas_ingredientes VALUES (25, 32, 107);
INSERT INTO public.receitas_ingredientes VALUES (3, 32, 43);
INSERT INTO public.receitas_ingredientes VALUES (400, 32, 44);
INSERT INTO public.receitas_ingredientes VALUES (1, 32, 47);
INSERT INTO public.receitas_ingredientes VALUES (200, 32, 51);
INSERT INTO public.receitas_ingredientes VALUES (1, 32, 54);
INSERT INTO public.receitas_ingredientes VALUES (1, 32, 63);
INSERT INTO public.receitas_ingredientes VALUES (120, 32, 69);
INSERT INTO public.receitas_ingredientes VALUES (120, 32, 73);
INSERT INTO public.receitas_ingredientes VALUES (120, 32, 79);
INSERT INTO public.receitas_ingredientes VALUES (25, 32, 80);
INSERT INTO public.receitas_ingredientes VALUES (200, 30, 105);
INSERT INTO public.receitas_ingredientes VALUES (1, 30, 62);
INSERT INTO public.receitas_ingredientes VALUES (350, 30, 78);
INSERT INTO public.receitas_ingredientes VALUES (200, 28, 103);
INSERT INTO public.receitas_ingredientes VALUES (70, 28, 104);
INSERT INTO public.receitas_ingredientes VALUES (3, 28, 43);
INSERT INTO public.receitas_ingredientes VALUES (2, 28, 62);
INSERT INTO public.receitas_ingredientes VALUES (2, 28, 63);
INSERT INTO public.receitas_ingredientes VALUES (75, 28, 80);
INSERT INTO public.receitas_ingredientes VALUES (3, 26, 43);
INSERT INTO public.receitas_ingredientes VALUES (1, 26, 62);
INSERT INTO public.receitas_ingredientes VALUES (200, 26, 69);
INSERT INTO public.receitas_ingredientes VALUES (395, 26, 78);
INSERT INTO public.receitas_ingredientes VALUES (2, 3, 43);
INSERT INTO public.receitas_ingredientes VALUES (100, 3, 51);
INSERT INTO public.receitas_ingredientes VALUES (20, 3, 25);
INSERT INTO public.receitas_ingredientes VALUES (400, 6, 36);
INSERT INTO public.receitas_ingredientes VALUES (100, 6, 93);
INSERT INTO public.receitas_ingredientes VALUES (2, 6, 43);
INSERT INTO public.receitas_ingredientes VALUES (50, 6, 52);
INSERT INTO public.receitas_ingredientes VALUES (200, 2, 51);
INSERT INTO public.receitas_ingredientes VALUES (600, 2, 44);
INSERT INTO public.receitas_ingredientes VALUES (300, 2, 79);
INSERT INTO public.receitas_ingredientes VALUES (100, 2, 110);
INSERT INTO public.receitas_ingredientes VALUES (200, 2, 76);
INSERT INTO public.receitas_ingredientes VALUES (240, 2, 73);
INSERT INTO public.receitas_ingredientes VALUES (1, 2, 54);
INSERT INTO public.receitas_ingredientes VALUES (60, 4, 113);
INSERT INTO public.receitas_ingredientes VALUES (15, 4, 70);
INSERT INTO public.receitas_ingredientes VALUES (0.25, 4, 62);
INSERT INTO public.receitas_ingredientes VALUES (75, 4, 61);
INSERT INTO public.receitas_ingredientes VALUES (1500, 5, 69);
INSERT INTO public.receitas_ingredientes VALUES (3, 5, 62);
INSERT INTO public.receitas_ingredientes VALUES (300, 5, 78);
INSERT INTO public.receitas_ingredientes VALUES (2, 5, 9);
INSERT INTO public.receitas_ingredientes VALUES (1, 5, 114);
INSERT INTO public.receitas_ingredientes VALUES (1, 7, 18);
INSERT INTO public.receitas_ingredientes VALUES (1, 7, 86);
INSERT INTO public.receitas_ingredientes VALUES (500, 7, 36);
INSERT INTO public.receitas_ingredientes VALUES (1, 7, 21);
INSERT INTO public.receitas_ingredientes VALUES (600, 7, 66);
INSERT INTO public.receitas_ingredientes VALUES (500, 7, 17);
INSERT INTO public.receitas_ingredientes VALUES (2, 7, 58);
INSERT INTO public.receitas_ingredientes VALUES (20, 7, 11);


--
-- TOC entry 4841 (class 0 OID 16497)
-- Dependencies: 222
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.usuarios VALUES ('gabrielbmota25@alu.ufc.br', 'Gabriel Mota', 'aaaaaa', NULL, NULL, 1, 'USER', NULL);
INSERT INTO public.usuarios VALUES ('hjudes@gmail.com', 'juju', 'nicolau', NULL, NULL, 3, 'USER', NULL);
INSERT INTO public.usuarios VALUES ('nnn', 'nicolavski', 'ssss', NULL, NULL, 4, 'USER', NULL);
INSERT INTO public.usuarios VALUES ('dsa', 's', 'das', 'dasd', 'sda', 5, 'USER', NULL);
INSERT INTO public.usuarios VALUES ('d', 's', 'dds', NULL, NULL, 6, 'USER', NULL);
INSERT INTO public.usuarios VALUES ('teste', 'teste', 'x', NULL, NULL, 7, 'USER', NULL);
INSERT INTO public.usuarios VALUES ('havillon@alu.ufc.br', 'Havillon Freitas', '$2a$12$Jp3eEyd0JgVHNd6VWQTdhezvfMtFGibMmN7iEIsd.nByfY9WkIYUS', NULL, NULL, 2, 'USER', NULL);


--
-- TOC entry 4671 (class 2606 OID 16503)
-- Name: pastas Favoritos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pastas
    ADD CONSTRAINT "Favoritos_pkey" PRIMARY KEY (id);


--
-- TOC entry 4669 (class 2606 OID 16505)
-- Name: ingredientes ingredientes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredientes
    ADD CONSTRAINT ingredientes_pkey PRIMARY KEY (id);


--
-- TOC entry 4673 (class 2606 OID 16507)
-- Name: pastas_receitas receitas_das_pastas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pastas_receitas
    ADD CONSTRAINT receitas_das_pastas_pkey PRIMARY KEY (pasta_id, receitas_id);


--
-- TOC entry 4677 (class 2606 OID 16509)
-- Name: receitas_ingredientes receitas_ingredientes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receitas_ingredientes
    ADD CONSTRAINT receitas_ingredientes_pkey PRIMARY KEY (receita_id, ingredientes_id);


--
-- TOC entry 4675 (class 2606 OID 16511)
-- Name: receitas receitas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receitas
    ADD CONSTRAINT receitas_pkey PRIMARY KEY (id);


--
-- TOC entry 4679 (class 2606 OID 16513)
-- Name: usuarios usuarios_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_email_key UNIQUE (email) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4681 (class 2606 OID 16516)
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);


--
-- TOC entry 4689 (class 2620 OID 16517)
-- Name: usuarios trigger1; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger1 BEFORE INSERT ON public.usuarios FOR EACH ROW EXECUTE FUNCTION public.trigger1_function();


--
-- TOC entry 4690 (class 2620 OID 16518)
-- Name: usuarios trigger2; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger2 AFTER INSERT ON public.usuarios FOR EACH ROW EXECUTE FUNCTION public.trigger2_function();


--
-- TOC entry 4687 (class 2620 OID 16519)
-- Name: pastas trigger3; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger3 BEFORE INSERT ON public.pastas FOR EACH ROW EXECUTE FUNCTION public.trigger3_function();


--
-- TOC entry 4688 (class 2620 OID 16520)
-- Name: receitas_ingredientes trigger_val_nutr_rec; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_val_nutr_rec AFTER INSERT ON public.receitas_ingredientes FOR EACH ROW EXECUTE FUNCTION public.func_val_nutr_rec();


--
-- TOC entry 4685 (class 2606 OID 16521)
-- Name: receitas_ingredientes id_ingredientes; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receitas_ingredientes
    ADD CONSTRAINT id_ingredientes FOREIGN KEY (ingredientes_id) REFERENCES public.ingredientes(id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED NOT VALID;


--
-- TOC entry 4683 (class 2606 OID 16526)
-- Name: pastas_receitas id_pastas; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pastas_receitas
    ADD CONSTRAINT id_pastas FOREIGN KEY (pasta_id) REFERENCES public.pastas(id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED NOT VALID;


--
-- TOC entry 4686 (class 2606 OID 16531)
-- Name: receitas_ingredientes id_receitas; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receitas_ingredientes
    ADD CONSTRAINT id_receitas FOREIGN KEY (receita_id) REFERENCES public.receitas(id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED NOT VALID;


--
-- TOC entry 4684 (class 2606 OID 16536)
-- Name: pastas_receitas id_receitas; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pastas_receitas
    ADD CONSTRAINT id_receitas FOREIGN KEY (receitas_id) REFERENCES public.receitas(id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED NOT VALID;


--
-- TOC entry 4682 (class 2606 OID 16541)
-- Name: pastas id_usuarios; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pastas
    ADD CONSTRAINT id_usuarios FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED NOT VALID;


-- Completed on 2025-07-24 09:47:23

--
-- PostgreSQL database dump complete
--

