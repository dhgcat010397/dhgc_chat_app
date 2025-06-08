import 'package:dhgc_chat_app/src/core/utils/dependencies_injection.dart';
import 'package:dhgc_chat_app/src/features/conversations/data/datasources/remote/conversation_remote_datasource.dart';
import 'package:dhgc_chat_app/src/features/conversations/data/datasources/remote/conversation_remote_datasource_impl.dart';
import 'package:dhgc_chat_app/src/features/conversations/data/repo/conversation_repo_impl.dart';
import 'package:dhgc_chat_app/src/features/conversations/domain/repo/conversation_repo.dart';
import 'package:dhgc_chat_app/src/features/conversations/domain/usecases/create_conversation.dart';
import 'package:dhgc_chat_app/src/features/conversations/domain/usecases/load_conversations.dart';
import 'package:dhgc_chat_app/src/features/conversations/presentation/bloc/conversations_bloc.dart';

Future<void> conversationInjectionContainer() async {
  // Register the ChatLocalDatasource
  // sl.registerLazySingleton<ChatLocalDatasource>(
  //   () => ChatLocalDatasourceImpl(),
  // );

  // Register the ConversationRemoteDatasource
  sl.registerLazySingleton<ConversationRemoteDatasource>(
    () => ConversationRemoteDatasourceImpl(
      firestoreService: sl(),
      chatRemoteDatasource: sl(),
      userRemoteDatasource: sl(),
    ),
  );

  // Register the ConversationRepo
  sl.registerLazySingleton<ConversationRepo>(
    () => ConversationRepoImpl(
      // localDatasource: sl(),
      remoteDatasource: sl(),
    ),
  );

  // Register the use cases
  sl.registerLazySingleton<CreateConversation>(() => CreateConversation(sl()));

  sl.registerLazySingleton<LoadConversations>(() => LoadConversations(sl()));

  // Register the ConversationsBloc
  sl.registerFactory<ConversationsBloc>(
    () => ConversationsBloc(createConversation: sl(), loadConversations: sl()),
  );
}
