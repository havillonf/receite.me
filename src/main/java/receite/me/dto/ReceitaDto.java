package receite.me.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Set;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class ReceitaDto {
    private Long id;
    private String nome;
    private Set<IngredienteDto> ingredientes;
    private double tempoDePreparo;
    private String modoDePreparo;
    private double caloriasTotais;
    private double proteinasTotais;
    private double carboidratosTotais;
    private double gordurasTotais;
    private boolean flagGluten;
    private boolean flagLactose;
    private boolean flagVegetariano;
    private boolean flagDoce;
    private boolean flagSalgado;
    private String pathImagem;
}
