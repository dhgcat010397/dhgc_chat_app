mixin ModelConvertible<I, O> {
  O toModel();
  I fromModel(O model) => throw UnimplementedError();
}
