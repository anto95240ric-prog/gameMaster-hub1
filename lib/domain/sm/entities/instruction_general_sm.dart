class InstructionGeneralSm {
  final int id;
  final int tactiqueId;
  final String? largeur;
  final String? mentalite;
  final String? tempo;
  final String? fluidite;
  final String? rythmeTravail;
  final String? creativite;

  InstructionGeneralSm({
    required this.id,
    required this.tactiqueId,
    this.largeur,
    this.mentalite,
    this.tempo,
    this.fluidite,
    this.rythmeTravail,
    this.creativite,
  });
}
