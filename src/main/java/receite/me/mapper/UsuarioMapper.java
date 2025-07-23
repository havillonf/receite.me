package receite.me.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;
import receite.me.dto.UsuarioDto;
import receite.me.model.Usuario;

@Mapper(componentModel = "spring")
public interface UsuarioMapper {
    UsuarioMapper INSTANCE = Mappers.getMapper(UsuarioMapper.class);

    UsuarioDto toDto(Usuario usuario);
    Usuario toEntity(UsuarioDto usuarioDto);
}
