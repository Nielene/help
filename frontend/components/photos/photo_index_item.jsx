import React from 'react';
import { Link } from 'react-router-dom';

class PhotoIndexItem extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    if(this.props.photo === undefined) {
      return null;
    } else {
      return(

        <li className="index-li">
          <img className="index-image" src={this.props.photo.image}/>
        </li>
    );}
  }
}

export default PhotoIndexItem;
