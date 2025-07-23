package receite.me.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.factory.Mappers;
import receite.me.dto.PastaDto;
import receite.me.model.Pasta;

@Mapper(componentModel = "spring")
public interface PastaMapper {
    PastaMapper INSTANCE = Mappers.getMapper(PastaMapper.class);

    @Mapping(source = "usuario.id", target = "usuarioId")
    PastaDto toDto(Pasta pasta);
    @Mapping(source = "usuarioId", target = "usuario.id")
    Pasta toEntity(PastaDto pastaDto);
}
