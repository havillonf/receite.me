package receite.me.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;
import receite.me.dto.IngredienteDto;
import receite.me.model.Ingrediente;

@Mapper(componentModel = "spring")
public interface IngredienteMapper {
    IngredienteMapper INSTANCE = Mappers.getMapper(IngredienteMapper.class);

    IngredienteDto toDto(Ingrediente ingrediente);
    Ingrediente toEntity(IngredienteDto ingredienteDto);
}
