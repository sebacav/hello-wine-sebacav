class ApplicationController < ActionController::API
    before_action :authorized

    # Metodo que nos permite encriptar datos en un formato en particular junto a una key Hash
    def encode_token(payload)
        # (datos_a_encriptar, Key HASH, Tipo de Encriptamiento)
        JWT.encode(payload, "secreto",'HS512')
    end

    # Metodo que nos permite obtener el token del header http
    def get_token
        request.headers['Authorization']
    end

    # Metodo que nos permite decodificar un token previamente encriptado
    def decoded_token
        if get_token
            begin
                # (datos_a_desencriptar, Key HASH, Tipo de Encriptamiento)
                JWT.decode(get_token, "secreto", true, algorithm: 'HS512')
            rescue JWT::DecodeError
            nil
            end
        end
    end

    # Metodo que nos permite validar si existe el usuario que viene en el token
    def logged_in_user
        # Se decodifica un token
        if decoded_token
            # Se obtiene la variable user_id dentro del token
            user_id = decoded_token[0]['user_id']
            # Se valida si existe realmente este usuario
            @user = User.find_by(id: user_id)
        end
    end

    # Metodo que valida si un usuario existe dado un token
    def logged_in?
        !!logged_in_user
    end

    # Metodo que valida un token y el usuario del token
    def authorized
        render status: :unauthorized unless logged_in?
    end

end

