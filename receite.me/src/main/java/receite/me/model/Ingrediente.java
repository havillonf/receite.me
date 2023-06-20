package receite.me.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
@Entity
@Getter
@Setter
@ToString
@Table(name = "Ingredientes", schema = "public")
public class Ingrediente {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String Nome;
    private double Calorias;
    private double Proteinas;
    private double Carboidratos;
    private double Gorduras;
    private String Medida;
    private double Quantidade;
}
