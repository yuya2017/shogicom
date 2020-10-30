import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {
  window.messageContainer = document.getElementById('message-container')
  if (messageContainer === null) {
    return
  }

  $(function() {
    const chatChannel = consumer.subscriptions.create({ channel: 'RoomChannel', room: $('#messages').data('room_id') }, {
      connected() {
      },

      disconnected() {
      },

      received(data) {
        messageContainer.insertAdjacentHTML('beforeend', data['message'])
        messageContent.value = ''
        scrollToBottom()
      }
    })
  });

  const documentElement = document.documentElement

  window.messageContent = document.getElementById('message_content')

  window.scrollToBottom = () => {
    window.scroll(0, documentElement.scrollHeight)
  }

  scrollToBottom()

  const messageButton = document.getElementById('message-button')

  const button_activation = () => {
    if (messageContent.value === '') {
      messageButton.classList.add('disabled')
    } else {
      messageButton.classList.remove('disabled')
    }
  }

  messageContent.addEventListener('input', () => {
    button_activation()
    changeLineCheck()
  })

  messageButton.addEventListener('click', () => {
    messageButton.classList.add('disabled')
    changeLineCount(1)
  })

  const maxLineCount = 10

  const getLineCount = () => {
    return (messageContent.value + '\n').match(/\r?\n/g).length;
  }

  let lineCount = getLineCount()
  let newLineCount

  const changeLineCheck = () => {
    newLineCount = Math.min(getLineCount(), maxLineCount)
    if (lineCount !== newLineCount) {
      changeLineCount(newLineCount)
    }
  }

  const footer = document.getElementById('fixed_bottom')
  let footerHeight = footer.scrollHeight
  let newFooterHeight, footerHeightDiff

  const changeLineCount = (newLineCount) => {
    messageContent.rows = lineCount = newLineCount
    newFooterHeight = footer.scrollHeight
    footerHeightDiff = newFooterHeight - footerHeight
    if (footerHeightDiff > 0) {
      messageContainer.style.paddingBottom = newFooterHeight + 'px'
      window.scrollBy(0, footerHeightDiff)
    } else {
      window.scrollBy(0, footerHeightDiff)
      messageContainer.style.paddingBottom = newFooterHeight + 'px'
    }
    footerHeight = newFooterHeight
  }
})
