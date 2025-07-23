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
public class PastaDto {
    private Long id;
    private String nome;
    private boolean flagFavorito;
    private Long usuarioId;
    private Set<ReceitaDto> receitas;
}
