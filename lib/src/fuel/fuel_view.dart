import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:tanker/src/controllers.dart';
import 'package:tanker/src/fuel/fuel_service.dart';

String? _validateUint(String? value) {
  if(value == null || value.isEmpty) {
    return "Vereist";
  }

  int? parsed = int.tryParse(value);
  if(parsed == null || parsed < 0) {
    return "Ongeldig getal";
  }

  return null;
}

String? _validateUdouble(String? value) {
  if(value == null || value.isEmpty) {
    return "Vereist";
  }

  double? parsed = double.tryParse(value);
  if(parsed == null || parsed < 0) {
    return "Ongeldig getal";
  }

  return null;
}

class FuelView extends StatelessWidget {
  const FuelView(this.controllers, {super.key});

  final Controllers controllers;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AnimatedBuilder(
          animation: controllers.fuelController,
          builder: (BuildContext context, Widget? child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text("Statistiek", style: GoogleFonts.roboto(fontSize: 20)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(right: 4.0),
                                  child: Icon(MdiIcons.fuel),
                                ),
                                Text("${_formatNaN(controllers.fuelController.getAvgKmPerLiter(), 1)} km/L", style: GoogleFonts.roboto()),
                              ],
                            ),
                            Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(right: 4.0),
                                  child: Icon(MdiIcons.currencyEur, size: 18),
                                ),
                                Text("${_formatNaN(controllers.fuelController.getAvgEurPerLiter(), 2)} €/L", style: GoogleFonts.roboto()),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: controllers.settingsController.getColorScheme().secondary,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
                  child: Text("Geschiedenis", style: GoogleFonts.roboto(fontSize: 20)),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: controllers.fuelController.tankEntries.length,
                    itemBuilder: (context, index) => _TankEntryViewWithContext(tankEntry: _sortedTankEntries()[index], controllers: controllers),
                  ),
                ),
              ],
            );
          }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (builder) => _CreateTankEntryView(controllers))),
      ),
    );
  }

  List<TankEntry> _sortedTankEntries() {
    List<TankEntry> copy = controllers.fuelController.tankEntries;
    copy.sort((a, b) => b.tankedAt.compareTo(a.tankedAt));
    return copy;
  }

  String _formatNaN(double f, int fractionDigits) {
    if(f.isNaN) {
      return "--";
    } else {
      return f.toStringAsFixed(fractionDigits);
    }
  }
}

class _CreateTankEntryView extends StatefulWidget {
  const _CreateTankEntryView(this.controllers);

  final Controllers controllers;

  @override
  State<_CreateTankEntryView> createState() => _CreateTankEntryViewState();
}

class _CreateTankEntryViewState extends State<_CreateTankEntryView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _litersTankedController = TextEditingController();
  final TextEditingController _tankedAtKmController = TextEditingController();
  final TextEditingController _tankedForEurController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tankbeurt toevoegen")
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _litersTankedController,
                decoration: const InputDecoration(
                  label: Text("Liters"),
                  suffixText: "L",
                  icon: Icon(MdiIcons.gasStationOutline),
                ),
                validator: _validateUdouble,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              TextFormField(
                controller: _tankedAtKmController,
                decoration: const InputDecoration(
                  label: Text("Kilometerstand"),
                  suffixText: "km",
                  icon: Icon(MdiIcons.counter),
                ),
                validator: _validateUint,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              TextFormField(
                controller: _tankedForEurController,
                decoration: const InputDecoration(
                  label: Text("Bedrag"),
                  icon: Icon(MdiIcons.currencyEur)
                ),
                validator: _validateUdouble,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () async {
          if(!_formKey.currentState!.validate()) {
            return;
          }

          List<int> ids = widget.controllers.fuelController.tankEntries.map((e) => e.id).toList();
          ids.sort();

          TankEntry entry = TankEntry(
            id: ids.isNotEmpty ? ids.last + 1 : 1,
            litersTanked: double.parse(_litersTankedController.text),
            tankedAtKm: int.parse(_tankedAtKmController.text),
            tankedAt: DateTime.now(),
            tankedForEur: double.parse(_tankedForEurController.text),
          );

          await widget.controllers.fuelController.addTankEntry(entry);
          if(!context.mounted) return;

          Navigator.of(context).pop();
        },
      ),
    );
  }
}

class _TankEntryViewWithContext extends StatefulWidget {
  final Controllers controllers;
  final TankEntry tankEntry;

  const _TankEntryViewWithContext({required this.tankEntry, required this.controllers});

  @override
  State<_TankEntryViewWithContext> createState() => _TankEntryViewWithContextState();
}

class _TankEntryViewWithContextState extends State<_TankEntryViewWithContext> {
  Offset _tapPosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _calculateTapPosition,
      onLongPress: _showContextMenu,
      child: _TankEntryView(widget.tankEntry),
    );
  }

  void _showContextMenu() async {
    final RenderObject overlay = Overlay.of(context).context.findRenderObject()!;
    final result = await showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 30, 30),
        Rect.fromLTWH(0, 0, overlay.paintBounds.size.width, overlay.paintBounds.size.height)
      ),
      items: [
        PopupMenuItem(
          value: 'remove',
          child: Row(
            children: const [
              Padding(
                padding: EdgeInsets.only(right: 4.0),
                child: Icon(MdiIcons.trashCan),
              ),
              Text("Remove")
            ],
          ),
        )
      ]
    );

    switch(result) {
      case "remove":
        await widget.controllers.fuelController.deleteTankEntry(widget.tankEntry.id);
        break;
    }
  }

  void _calculateTapPosition(TapDownDetails details) {
    setState(() {
      _tapPosition = details.globalPosition;
    });
  }
}

class _TankEntryView extends StatelessWidget {
  _TankEntryView(this.tankEntry);

  final TankEntry tankEntry;
  final DateFormat formatter = DateFormat("dd-MM-yyyy");

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formatter.format(tankEntry.tankedAt.toLocal()),
              style: GoogleFonts.roboto(fontSize: 19),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 4.0),
                      child: Icon(MdiIcons.gasStationOutline),
                    ),
                    Text("${tankEntry.litersTanked}L", style: GoogleFonts.roboto()),
                  ],
                ),
                Text("€${tankEntry.tankedForEur.toStringAsFixed(2)}", style: GoogleFonts.roboto()),
              ],
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 4.0),
                  child: Icon(MdiIcons.counter),
                ),
                Text("${tankEntry.tankedAtKm} km", style: GoogleFonts.roboto()),
              ],
            )
          ],
        ),
      ),
    );
  }
}