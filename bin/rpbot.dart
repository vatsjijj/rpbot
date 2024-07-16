import 'dart:io';
import 'package:rpbot/commands.dart' as commands;
import 'package:rpbot/character.dart' as character;
import 'package:rpbot/context.dart' as context;
import 'package:nyxx/nyxx.dart';
import 'dart:convert';

void main() async {
  final ttk = File('ttk.txt').readAsStringSync();
  final client = await Nyxx.connectGateway(
    ttk,
    GatewayIntents.allUnprivileged,
    options: GatewayClientOptions(plugins: [logging, cliIntegration]),
  );

  /*
  await client.commands.create(ApplicationCommandBuilder.chatInput(
      name: 'ping', description: 'Ping the bot.', options: []));
  await client.commands.create(ApplicationCommandBuilder.chatInput(
      name: 'debuffs', description: 'Lists all debuffs.', options: []));
  await client.commands.create(ApplicationCommandBuilder.chatInput(
      name: 'buffs', description: 'Lists all buffs.', options: []));
  await client.commands.create(ApplicationCommandBuilder.chatInput(
      name: 'shade', description: 'Shade.', options: []));
  await client.commands.create(ApplicationCommandBuilder.chatInput(
      name: 'help', description: 'Displays a help message.', options: []));
  await client.commands
    ..create(ApplicationCommandBuilder.chatInput(
        name: 'roll',
        description: 'Roll a D20 with DC.',
        options: [
          CommandOptionBuilder.integer(
              name: 'dc', description: 'Difficulty class.', isRequired: true)
        ]))
    ..create(ApplicationCommandBuilder.chatInput(
        name: 'advantage',
        description: 'Roll a D20 with DC for advantage.',
        options: [
          CommandOptionBuilder.integer(
              name: 'dc', description: 'Difficulty class.', isRequired: true)
        ]))
    ..create(ApplicationCommandBuilder.chatInput(
        name: 'disadvantage',
        description: 'Roll a D20 with DC for disadvantage.',
        options: [
          CommandOptionBuilder.integer(
              name: 'dc', description: 'Difficulty class.', isRequired: true)
        ]));
  */
  await client.commands.create(ApplicationCommandBuilder.chatInput(
      name: 'register',
      description: 'Register a character.',
      options: [
        CommandOptionBuilder.string(
            name: 'name',
            description: 'Name of the character.',
            isRequired: true),
      ]));
  await client.commands.create(ApplicationCommandBuilder.chatInput(
      name: 'unregister',
      description: 'Unregister a character.',
      options: [
        CommandOptionBuilder.string(
            name: 'name',
            description: 'Name of the character.',
            isRequired: true),
      ]));

  client.onApplicationCommandInteraction.listen(commands.handleEvent);

  if (!await File('context.ctx').exists()) {
    print('Context file does not exist!');
  } else {
    final json = await File('context.ctx').readAsString();
    commands.ctx = jsonDecode(json);
  }
}
