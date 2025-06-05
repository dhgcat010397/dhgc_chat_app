import 'package:dhgc_chat_app/src/core/utils/dependencies_injection.dart';
import 'package:dhgc_chat_app/src/features/chat/data/datasources/remote/chat_remote_datasource.dart';
import 'package:dhgc_chat_app/src/features/chat/data/datasources/remote/chat_remote_datasource._impl.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/repo/chat_repo.dart';
import 'package:dhgc_chat_app/src/features/chat/data/repo/chat_repo_impl.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/usecases/load_messages.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/usecases/load_more_messages.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/usecases/send_text_message.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/usecases/send_image_message.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/usecases/mark_message_as_seen.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/usecases/start_call.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/usecases/end_call.dart';
import 'package:dhgc_chat_app/src/features/chat/domain/usecases/delete_conversation.dart';
import 'package:dhgc_chat_app/src/features/chat/presentation/bloc/chat_bloc.dart';

Future<void> chatInjectionContainer() async {
  // Register the ChatLocalDatasource
  // sl.registerLazySingleton<ChatLocalDatasource>(
  //   () => ChatLocalDatasourceImpl(),
  // );

  // Register the ChatRemoteDatasource
  sl.registerLazySingleton<ChatRemoteDatasource>(
    () =>
        ChatRemoteDatasourceImpl(firestoreService: sl(), storageService: sl()),
  );

  // Register the NoteRepo
  sl.registerLazySingleton<ChatRepo>(
    () => ChatRepoImpl(
      // localDatasource: sl(),
      remoteDatasource: sl(),
    ),
  );

  // Register the use cases
  sl.registerLazySingleton<LoadMessages>(() => LoadMessages(sl()));

  sl.registerLazySingleton<LoadMoreMessages>(() => LoadMoreMessages(sl()));

  sl.registerLazySingleton<SendTextMessage>(() => SendTextMessage(sl()));

  sl.registerLazySingleton<SendImageMessage>(() => SendImageMessage(sl()));

  sl.registerLazySingleton<MarkMessageAsSeen>(() => MarkMessageAsSeen(sl()));

  sl.registerLazySingleton<StartCall>(() => StartCall(sl()));

  sl.registerLazySingleton<EndCall>(() => EndCall(sl()));

  sl.registerLazySingleton<DeleteConversation>(() => DeleteConversation(sl()));

  // Register the LoginBloc
  sl.registerFactory<ChatBloc>(
    () => ChatBloc(
      loadMessages: sl(),
      loadMoreMessages: sl(),
      sendTextMessage: sl(),
      sendImageMessage: sl(),
      markMessagesAsSeen: sl(),
      startCall: sl(),
      endCall: sl(),
      deleteConversation: sl(),
    ),
  );
}
