import React, { Component } from "react";
import Cause from "../cause/Cause";
import causeService from "../../services/causeService";

class ViewCausesComponent extends Component {
  constructor() {
    super();
    this.state = {
      causes: [],
    };

    this.retrieveCauses = this.retrieveCauses.bind(this);
  }

  componentDidMount() {
    this.retrieveCauses();
  }

  componentDidUpdate() {}

  retrieveCauses() {
    causeService.retrieveCauses();
    //   .then((res) => res.json()) //TODO - consider how
    //   .then((json) => this.setState({ causes: json.causes })) //TODO - consider how
    //   .catch((err) => {
    // console.log("err is " + err.message);
    //   });
  }

  render() {
    return (
      <div className="ViewCauses">
        <br />
        <br />
        <h3 className="title"> Causes available for donations: </h3>
        <div className="col-lg-11">
          <div className="row">
            {this.state.causes.map((cause) => {
              return <Cause key={cause.title} cause={cause} />;
            })}
          </div>
        </div>
      </div>
    );
  }
}

export default ViewCausesComponent;
