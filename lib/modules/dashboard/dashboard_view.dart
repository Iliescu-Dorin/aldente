import 'package:aldente/models/chat_room.dart';
import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/pocketbase_service.dart';
import 'dashboard_controller.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.put(DashboardController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: controller.loadRooms,
          icon: const Icon(Icons.refresh),
        ),
        actions: [
          IconButton(
            onPressed: controller.addNewRoom,
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: controller.onLogoutTap,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : controller.rooms.isEmpty
              ? const Center(child: Text("No chats, add new chat +"))
              : ListView.builder(
                  itemCount: controller.rooms.length,
                  itemBuilder: (BuildContext context, int index) {
                    ChatRoom room = controller.rooms[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                          title: Text(room.name ?? "No name"),
                          subtitle: LastMessageBuilder(chatRoom: room),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onLongPress: () => controller.onRoomLongTap(room),
                          onTap: () => controller.onRoomTap(room),
                        ),
                      ),
                    );
                  },
                )),
    );
  }
}

class LastMessageBuilder extends StatelessWidget {
  final ChatRoom chatRoom;
  const LastMessageBuilder({super.key, required this.chatRoom});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PocketbaseService.to
          .getMessages(roomId: chatRoom.id, chatId: chatRoom.chatId),
      initialData: const <Message>[],
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        List<Message> messages = snapshot.data ?? [];
        if (messages.isEmpty) {
          return const Text("No messages");
        }
        Message message = messages.first;
        if (message.messageType == MessageType.image) {
          return Text("Image message from : ${message.sendBy}");
        } else if (message.messageType == MessageType.voice) {
          return Text("Voice message from : ${message.sendBy}");
        }
        return Text(message.message);
      },
    );
  }
}
