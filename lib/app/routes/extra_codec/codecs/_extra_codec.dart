/// Interface for encoding/decoding a specific type.
abstract class ExtraCodec<T> {
  const ExtraCodec();

  /// Unique identifier for the type.
  String get typeId;

  /// Encodes the input to a JSON-serializable format.
  Object? encode(T input);

  /// Decodes the input to the original type.
  T decode(Object? input);
}
