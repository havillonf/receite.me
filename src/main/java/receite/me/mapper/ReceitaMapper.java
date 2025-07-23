package receite.me.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;
import receite.me.dto.ReceitaDto;
import receite.me.model.Receita;

@Mapper(componentModel = "spring")
public interface ReceitaMapper {
    ReceitaMapper INSTANCE = Mappers.getMapper(ReceitaMapper.class);

    ReceitaDto toDto(Receita receita);
    Receita toEntity(ReceitaDto receitaDto);
}
