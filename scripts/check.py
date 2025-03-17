import discord
from dotenv import load_dotenv
import os

load_dotenv()

TOKEN = os.getenv('TOKEN_BOT')
CHANNEL_ID = int(os.getenv('ID_CHANNEL'))

intents = discord.Intents.default()
intents.messages = True
intents.message_content = True


class MyClient(discord.Client):
    def __init__(self, *, intents):
        super().__init__(intents=intents)
        self.embed_description = []

    async def on_ready(self):
        print(f'✅ Bot conectado como {self.user}')
        
        # Verificar se o bot está em algum servidor
        if not self.guilds:
            print("🚨 O bot não está em nenhum servidor. Verifique se foi adicionado corretamente.")
            await self.close()
            return
        
        # Listar os servidores em que o bot está
        for guild in self.guilds:
            print(f'📌 Conectado ao servidor: {guild.name} (ID: {guild.id})')

        try:
            # Verificar se o bot consegue acessar o canal
            channel = self.get_channel(CHANNEL_ID)
            
            if channel is None:
                print(f"🚨 Erro: O bot não encontrou o canal com ID {CHANNEL_ID}.")
                print("➡️ Certifique-se de que o ID está correto e que o bot tem acesso ao canal.")
                await self.close()
                return
        
            print(f'📩 Lendo mensagens do canal: {channel.name}')

            messages = [msg async for msg in channel.history(limit=int(os.getenv('LIMIT_MSG')))]
            if not messages:
                print("⚠️ Nenhuma mensagem encontrada no histórico.")
            else:
                for msg in messages:
                    if msg.embeds:
                        for embed in msg.embeds:
                            self.embed_description.append(embed.description)
                            # print(f"📜 Título: {embed.title}")
                            # print(f"📝 Descrição: {embed.description}")
                            # print(f"🔗 URL: {embed.url if embed.url else 'Sem URL'}")
                    else:
                        print(f"💬 {msg.author}: {msg.content}")
        except discord.errors.Forbidden:
            print("🚨 O bot não tem permissão para ler o histórico de mensagens.")
            print("➡️ Vá até as configurações do canal no Discord e ative 'Read Message History' e 'Read Messages' para o bot.")
        await self.close()

def main():
    client = MyClient(intents=intents)
    client.run(TOKEN)

    return client.embed_description