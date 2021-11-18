import 'package:app_filmes/application/rest_client/rest_client.dart';
import 'package:app_filmes/models/genre_model.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import './genres_repository.dart';

class GenresRepositoryImpl implements GenresRepository {
  final RestClient _restCliente;

  GenresRepositoryImpl({
    required RestClient restClient,
  }) : _restCliente = restClient;

  @override
  Future<List<GenreModel>> getGenres() async {
    final result = await _restCliente.get<List<GenreModel>>('/genre/movie/list', query: {
      'api_key': RemoteConfig.instance.getString('api_token'),
      'language': 'pt-br',
    }, decoder: (data) {
      final resultData = data['genres'];
      if (resultData != null) {
        return resultData.map<GenreModel>((g) => GenreModel.fromMap(g)).toList();
      }
      return <GenreModel>[];
    });

    if (result.hasError) {
      throw Exception('Erro ao buscar Gêneros');
    }

    return result.body ?? <GenreModel>[];
  }
}
