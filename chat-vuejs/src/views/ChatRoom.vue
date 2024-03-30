<template>
  <div class="container">
    <NavBar />
    <ChatWindow v-on:connectCable="connectCable" v-bind:messages="messages" />
    <NewChatForm v-on:connectCable="connectCable" />
  </div>
</template>
  
<script>
import NavBar from '../components/NavBar.vue'
import ChatWindow from '../components/ChatWindow.vue'
import NewChatForm from '../components/NewChatForm.vue'
import axios from 'axios'
import ActionCable from 'actioncable'

  export default {
    components: {
      NavBar,
      ChatWindow,
      NewChatForm,
    },
    data () {
      return {
        messages: [],
      }
    },
    methods: {
      async getMessages () {
        try {
          const res = await axios.get('http://127.0.0.1:3000/messages', {
            headers: {
              uid: window.localStorage.getItem('uid'),
              "access-token": window.localStorage.getItem('access-token'),
              client:window.localStorage.getItem('client')
            }
          })
          if (!res) {
            new Error('メッセージ一覧を取得できませんでした')
          }
          this.messages = res.data
        } catch (err) {
          console.log(err)
        }
      },
      connectCable (message) {
        this.messageChannel.perform('receive', {
          message: message,
          email: window.localStorage.getItem('uid')
        })
      }
    },
    mounted() {
      const cable = ActionCable.createConsumer('ws://127.0.0.1:3000/cable')
        this.messageChannel = cable.subscriptions.create('RoomChannel', {
          connected: () => {
            this.getMessages()
          },
          received: () => {
            this.getMessages()
          }
        })
    },
    beforeUnmount () { 
      this.messageChannel.unsubscribe()
    } 
  }
</script>

<style scoped>

</style>
  