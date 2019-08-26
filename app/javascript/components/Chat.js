import React from "react";
import PropTypes from "prop-types";

export default class Chat extends React.Component {
  static propTypes = {
    chatName: PropTypes.string.isRequired,
    users: PropTypes.array.isRequired,
    messagesPath: PropTypes.string.isRequired,
    createMessagePath: PropTypes.string.isRequired,
    messages: PropTypes.array.isRequired
  }

  constructor(props) {
    super(props)
    this.handleSubmit = this.handleSubmit.bind(this)
    this.refreshMessages = this.refreshMessages.bind(this)
  }

  componentWillMount() {
    this.setState({ messages: this.props.messages })
    this.refreshMessages()
    setTimeout(this.refreshMessages, 1500)
  }

  scrollToBottom() {
    let messagesDiv = this.refs.messagesDiv;
    messagesDiv.scrollTop = messagesDiv.scrollHeight - messagesDiv.clientHeight;
  }

  componentDidMount() { this.scrollToBottom(); }

  componentWillUnmount() {
    this.isUnmounted = true;
  }

  refreshMessages() {
    if (this.isUnmounted) { return; }
    let thisComponent = this;
    $.get(this.props.messagesPath)
      .done(function(data) {
        thisComponent.setState({ messages: data.messages });
        thisComponent.scrollToBottom()
        setTimeout(thisComponent.refreshMessages, 1500);
      }).fail(function(data) {
        setTimeout(thisComponent.refreshMessages, 3000);
      });
  }

  handleSubmit(e) {
    e.preventDefault();
    $(this.refs.submit).prop('disabled', true);

    let optimisticallyCreatedMessage = { id: Math.random(),
                                         body: this.refs.bodyInput.value,
                                         created_at_in_words: 'less than a minute ago',
                                         user: { id: App.currentUser().id,
                                                 full_name: App.currentUser().full_name,
                                                 gravatar_url: App.currentUser().gravatar_url }
    }

    let newMessages = [...this.state.messages]
    newMessages.unshift(optimisticallyCreatedMessage)
    this.setState({ messages: newMessages });

    let thisComponent = this;
    $.post(this.props.createMessagePath,
           { message: { body: this.refs.bodyInput.value },
             authenticity_token: App.getMetaContent("csrf-token") })
        .done(function(data) {
                  thisComponent.refs.bodyInput.value = '';
                  thisComponent.refs.submit.blur();
                })
        .fail(function(data) {
                let messages = thisComponent.state.messages;
                let messageIndex = messages.indexOf(optimisticallyCreatedMessage);
                messages.splice(messageIndex, 1);

                // TODO: show errorMessage
                let errorMessage = 'Oops, your message failed to post. Contact the site maintainer if this persists.';

                thisComponent.setState({ errorMessage: errorMessage,
                                         messages: messages });

                // $(thisComponent.refs.noticeDiv).show();
                // setTimeout(function() { $(thisComponent.refs.noticeDiv).fadeOut(500); }, 5000);
              })
        .always(function() { $(thisComponent.refs.submit).prop('disabled', false); });
  }

  render() {
    let renderUserIcon = function(user) {
      return (<img className="chat-avatar float-left" src={user.gravatar_url}/>)
    }

    let renderMessage = function(message) {
      if (message.user.id == App.currentUser().id)
        return (
          <div key={message.id} className="current-user p-2 m-0 position-relative" data-is={ `You - ${message.created_at_in_words}` }>
          	<a className="float-right">{ message.body }</a>
          </div>
        )
      else
        return (
          <div key={message.id} className="other-user p-2 m-0 position-relative" data-is={ `${message.user.full_name} - ${message.created_at_in_words}` }>
          	<a className="float-left">{ message.body }</a>
          </div>
        )
      end
    }

    return (
      <div className="chat">
        <div className="jumbotron m-0 p-0 bg-transparent">
      		<div className="row m-0 p-0 position-relative">
      		  <div className="col-12 p-0 m-0 position-absolute" style={ { right: '0px' } }>
      			<div className="card border-0 rounded" style={ { boxShadow: "0 2px 4px 0 rgba(0, 0, 0, 0.10), 0 6px 10px 0 rgba(0, 0, 0, 0.01)", overflow: 'hidden' } }>

      			  <div className="card-header bg-light border border-top-0 border-left-0 border-right-0" style={ { color: "rgba(96, 125, 139,1.0)" } }>
                <h6 className='mb-1'>{ this.props.chatName }</h6>
      			  </div>

      				<div className="card bg-sohbet border-0 m-0 p-0" style={ { height: '60vh' } }>
        			  <div ref='messagesDiv' className="messages card border-0 m-0 p-0 position-relative bg-transparent" style={ { overflowY: 'auto', height: '60vh' } }>
                  { this.state.messages.map(renderMessage) }
        			  </div>
      			  </div>

              <hr/>

              <form ref='form' className="m-0 p-0 chat-message-form" onSubmit={this.handleSubmit} autoComplete="off">
                <div className="row m-0 p-0">
                  <div className="col-9 m-0 p-1">
                    <input className="mw-100 border rounded form-control" required={true} type="text" ref="bodyInput" name="text" title="Type a message..." placeholder="Type a message..." required />
                  </div>
                  <div className="col-3 m-0 p-1">
                    <button ref="submit" className="btn btn-outline-secondary rounded border w-100" title="Gönder!" style= { { paddingRight: '16px' } }><i className="fa fa-paper-plane" aria-hidden="true"></i></button>
                  </div>
                </div>
              </form>

      			</div>
      		  </div>

      		</div>
  	    </div>
	    </div>
    );
  }
}
