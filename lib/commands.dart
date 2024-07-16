import 'dart:io';
import 'package:rpbot/status.dart' as status;
import 'package:rpbot/algo.dart' as algo;
import 'package:rpbot/context.dart' as context;
import 'dart:convert';
import 'package:nyxx/nyxx.dart';

var ctx = context.Context();

final commands = {
  'help': 'Shows this message.',
  'ping': 'Pings the bot.',
  'debuffs': 'Lists all debuffs.',
  'buffs': 'Lists all buffs.',
  'shade': 'Shade.',
  'roll': 'Roll a D20 with DC.',
  'advantage': 'Roll a D20 with DC for advantage.',
  'disadvantage': 'Roll a D20 with DC for disadvantage.',
  'register': 'Registers a character.',
  'unregister': 'Unregisters a character.',
  'characters': 'Lists all characters.',
  'debuff': 'Debuffs a character.',
  'buff': 'Buffs a character.',
  'status': 'Check the status of a character.',
};

typedef Event = InteractionCreateEvent<ApplicationCommandInteraction>;

Future<void> respondMessage(Event event, String message) async {
  await event.interaction.respond(MessageBuilder(content: message));
}

void handleEvent(Event event) async {
  final name = event.interaction.data.name;
  switch (name) {
    case 'ping':
      await respondMessage(event, 'Pong!');
    case 'help':
      await help(event);
    case 'debuffs':
      await listDebuffs(event);
    case 'buffs':
      await listBuffs(event);
    case 'shade':
      await shade(event);
    case 'roll':
      await roll(event);
    case 'advantage':
      await advantage(event);
    case 'disadvantage':
      await disadvantage(event);
    case 'register':
      await register(event);
    case 'unregister':
      await unregister(event);
    case 'characters':
      await characters(event);
    case 'debuff':
      await debuff(event);
    case 'buff':
      await buff(event);
    case 'status':
      await stats(event);
  }
}

Future<void> help(Event event) async {
  String result = '';
  commands.forEach((k, v) {
    result += '- */$k:* **$v**\n';
  });
  await respondMessage(event, result);
}

Future<void> listDebuffs(Event event) async {
  String result = '';
  status.debuffs.forEach((k, v) {
    result += '- *$k:* **$v**\n';
  });
  await respondMessage(event, result);
}

Future<void> listBuffs(Event event) async {
  String result = '';
  status.buffs.forEach((k, v) {
    result += '- *$k:* **$v**\n';
  });
  await respondMessage(event, result);
}

Future<void> shade(Event event) async {
  await respondMessage(event,
      'https://cdn.discordapp.com/attachments/1236785809659662467/1237257228910596096/Screenshot_20240505-180527.png?ex=66969d56&is=66954bd6&hm=8be5730869fd54a71d534c8266a3fab78d2786bd772608f49d605f7a7f8d9423&');
}

Future<void> roll(Event event) async {
  final dc = event.interaction.data.options?.elementAt(0).value as int;

  if (dc > 30) {
    await respondMessage(event, 'DC cannot be above 30!');
    return;
  } else if (dc < 1) {
    await respondMessage(event, 'DC cannot be below 1!');
    return;
  }

  final roll = algo.rollD20();
  var result = 'You rolled $roll with a DC of $dc.\n';
  final success = roll >= dc;
  result += 'The result of your action was... ';
  result += '**${success ? 'Success' : 'Failure'}.**';

  await respondMessage(event, result);
}

Future<void> advantage(Event event) async {
  final dc = event.interaction.data.options?.elementAt(0).value as int;

  if (dc > 30) {
    await respondMessage(event, 'DC cannot be above 30!');
    return;
  } else if (dc < 1) {
    await respondMessage(event, 'DC cannot be below 1!');
    return;
  }

  final roll1 = algo.rollD20();
  final roll2 = algo.rollD20();
  var result = 'You rolled $roll1 and $roll2 for advantage with a DC of $dc.\n';
  final hi = roll1 > roll2 ? roll1 : roll2;
  final success = hi >= dc;
  result += 'The result of your action was... ';
  result += '**${success ? 'Success' : 'Failure'}.**';

  await respondMessage(event, result);
}

Future<void> disadvantage(Event event) async {
  final dc = event.interaction.data.options?.elementAt(0).value as int;

  if (dc > 30) {
    await respondMessage(event, 'DC cannot be above 30!');
    return;
  } else if (dc < 1) {
    await respondMessage(event, 'DC cannot be below 1!');
    return;
  }

  final roll1 = algo.rollD20();
  final roll2 = algo.rollD20();
  var result =
      'You rolled $roll1 and $roll2 for disadvantage with a DC of $dc.\n';
  final lo = roll1 < roll2 ? roll1 : roll2;
  final success = lo >= dc;
  result += 'The result of your action was... ';
  result += '**${success ? 'Success' : 'Failure'}.**';

  await respondMessage(event, result);
}

Future<void> register(Event event) async {
  final name = algo.sentenceCase(
      event.interaction.data.options?.elementAt(0).value as String);

  bool status = !ctx.addCharacter(name);

  if (status) {
    await respondMessage(event, 'Character could not be created!');
    return;
  }
  await respondMessage(event, '$name was created.');

  var f = File('context.ctx').openWrite();
  final json = jsonEncode(ctx);
  f.write(json);
  f.close();
}

Future<void> unregister(Event event) async {
  final name = algo.sentenceCase(
      event.interaction.data.options?.elementAt(0).value as String);

  if (!ctx.removeCharacter(name)) {
    await respondMessage(event, 'Character could not be unregistered!');
    return;
  }
  await respondMessage(event, '$name was unregistered.');

  var f = File('context.ctx').openWrite();
  final json = jsonEncode(ctx);
  f.write(json);
  f.close();
}

Future<void> characters(Event event) async {
  var str = 'Characters:\n';
  ctx.characters.forEach((k, v) => str += '- *$k*\n');
  await respondMessage(event, str);
}

Future<void> debuff(Event event) async {
  final name = algo.sentenceCase(
      event.interaction.data.options?.elementAt(0).value as String);
  final debuff = algo.sentenceCase(
      event.interaction.data.options?.elementAt(1).value as String);

  if (!ctx.characters.containsKey(name)) {
    await respondMessage(event, '$name does not exist!');
    return;
  } else if (!status.debuffs.containsKey(debuff)) {
    await respondMessage(event, '$debuff does not exist!');
    return;
  } else if (ctx.characters[name]!.debuffs.contains(debuff)) {
    ctx.characters[name]?.debuffs.remove(debuff);
    ctx.characters[name]?.total += status.debuffs[debuff]!;
    await respondMessage(event, '$name no longer has $debuff!');
    return;
  }

  ctx.characters[name]?.debuffs.add(debuff);
  ctx.characters[name]?.total -= status.debuffs[debuff]!;

  await respondMessage(event, '$name has been inflicted with $debuff!');

  var f = File('context.ctx').openWrite();
  final json = jsonEncode(ctx);
  f.write(json);
  f.close();
}

Future<void> buff(Event event) async {
  final name = algo.sentenceCase(
      event.interaction.data.options?.elementAt(0).value as String);
  final buff = algo.sentenceCase(
      event.interaction.data.options?.elementAt(1).value as String);

  if (!ctx.characters.containsKey(name)) {
    await respondMessage(event, '$name does not exist!');
    return;
  } else if (!status.buffs.containsKey(buff)) {
    await respondMessage(event, '$buff does not exist!');
    return;
  } else if (ctx.characters[name]!.buffs.contains(buff)) {
    ctx.characters[name]?.buffs.remove(buff);
    ctx.characters[name]?.total -= status.buffs[buff]!;
    await respondMessage(event, '$name no longer has $buff!');
    return;
  }

  ctx.characters[name]?.buffs.add(buff);
  ctx.characters[name]?.total += status.buffs[buff]!;

  await respondMessage(event, '$name has been improved with $buff!');

  var f = File('context.ctx').openWrite();
  final json = jsonEncode(ctx);
  f.write(json);
  f.close();
}

Future<void> stats(Event event) async {
  final name = algo.sentenceCase(
      event.interaction.data.options?.elementAt(0).value as String);

  if (!ctx.characters.containsKey(name)) {
    await respondMessage(event, '$name does not exist.');
    return;
  }

  var result = '## $name\n';

  result += 'Character total: **${ctx.characters[name]?.total}**\nBuffs:\n';

  ctx.characters[name]?.buffs.forEach((e) => result += '- *$e*\n');

  result += 'Debuffs:\n';

  ctx.characters[name]?.debuffs.forEach((e) => result += '- *$e*\n');

  await respondMessage(event, result);
}
