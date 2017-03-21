import { ApolloClient, createNetworkInterface } from 'react-apollo'

const networkInterface = createNetworkInterface({
  uri: 'http://localhost:3001/graphql'
})

const client = new ApolloClient({
  networkInterface: networkInterface
})

export default client
