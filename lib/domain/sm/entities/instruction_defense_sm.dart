class InstructionDefenseSm {
  final int id;
  final int tactiqueId;
  final String? pressing;
  final String? styleTacle;
  final String? ligneDefensive;
  final String? gardienLibero;
  final String? perteTemps;

  InstructionDefenseSm({
    required this.id,
    required this.tactiqueId,
    this.pressing,
    this.styleTacle,
    this.ligneDefensive,
    this.gardienLibero,
    this.perteTemps,
  });
}
