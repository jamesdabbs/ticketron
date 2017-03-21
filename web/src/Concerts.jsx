import React, { Component } from 'react'
import moment from 'moment'

import { gql, graphql } from 'react-apollo'

const Artists = ({artists}) => {
  const components = []

  for(let i=0, l=artists.length; i<l; i++) {
    components[2*i] = <span key={2*i} className="artist">{artists[i].name}</span>
    components[2*i + 1] = <small key={2*i + 1}>,</small>
  }
  components.pop()
  components[components.length - 2] = <small key={components.length - 2}>and</small>
  components[1] = <small key={1}>with</small>

  return (
    <span className="artists">
      {components}
    </span>
  )
}

const Statuses = [
    ['to_order',  'Watching',    'You still need to order tickets', 'eye-open'],
    ['by_mail',   'In the Mail', 'Your tickets are being mailed to you', 'envelope'],
    ['in_hand',   'In Hand',     'You\'ve got your tickets in hand', 'ok'],
    ['to_print',  'To Print',    'You will need to print your tickets', 'print'],
    ['will_call', 'Will Call',   'Tickets are at will call', 'phone'],
]

class RSVPButtons extends Component {
  render() {
    const {concert} = this.props
    const rsvp = 'will_call'

    return (
      <div className="btn-group-vertical rsvp-btns">
        {Statuses.map(([key, name, desc, icon]) =>
          <a
            key={key}
            href="#"
            title={desc}
            className={`btn btn-primary btn-sm ${key === rsvp ? 'active' : ''}`}
          >
            <span className={`glyphicon glyphicon-${icon}`}/>
          </a>
        )}
      </div>
    )
  }
}

class Concert extends Component {
  render() {
    const { concert } = this.props

    const at = moment(concert.at)

    return (
      <article className="concert">
        <div className="row">
          <div className="col-md-2">
            <h3>{concert.venue.name}</h3>
            <h4>{at.format('MMM Do')}</h4>
          </div>
          <div className="col-md-1">
            <RSVPButtons concert={concert}/>
          </div>
          <div className="col-md-9">
            <h2>
              <Artists artists={concert.artists}/>

              <a href={`https://songkick.com/concerts/${concert.songkick_id}`}>
                <img className="sk-badge" src="img/sk-badge-pink.png" alt="View on Songkick"/>
              </a>
            </h2>
          </div>
        </div>
      </article>
    )
  }
}

class Concerts extends Component {
  render() {
    if (!this.props.data.viewer) { return null }

    const { concerts } = this.props.data.viewer

    return (
      <div>
        {concerts.map(c =>
          <Concert key={c.songkick_id} concert={c}/>
        )}
      </div>
    )
  }
}

export default graphql(gql`
  query {
    viewer {
      concerts {
        artists {
          name
        }
        venue {
          name
        }
        songkick_id
        at
      }
    }
  }
`)(Concerts)
