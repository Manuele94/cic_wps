abstract class Enum<T> {
  final T value;

  const Enum(this.value);
}

class SapMessageType<String> extends Enum<String> {
  const SapMessageType(String val) : super(val);

  static const SapMessageType E = const SapMessageType("E");
  static const SapMessageType W = const SapMessageType("W");
  static const SapMessageType S = const SapMessageType("S");
}
