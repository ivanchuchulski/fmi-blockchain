import React, { Component } from "react";
import "./Cause.css";
import { Button } from "react-bootstrap";

class Cause extends Component {
  constructor(props) {
    super(props);

    this.state = {};

    this.donateToCause = this.donateToCause.bind(this);
  }

  donateToCause = (event) => {
    event.preventDefault();
    const causeTitle = this.props.cause.title;
    //TODO - call donate method in cause service and handle it
    //TODO - add notification message
  };

  render() {
    return (
      <div className="Cause">
        {
          <div className="card h-100">
            <div className="card-body">
              <div className="img">
                <img className="causeImg" src={this.props.cause.img}></img>
              </div>
              <div className="causeInfo">
                {this.props.cause.title},{this.props.cause.description}
              </div>
              <div className="buttons-section">
                <Button
                  href={"/view-cause/" + this.props.cause.title}
                  className="button"
                >
                  Details
                </Button>

                <button className="button" onClick={this.donateToCause}>
                  Donate
                </button>
              </div>
            </div>
          </div>
        }
      </div>
    );
  }
}

export default Cause;
