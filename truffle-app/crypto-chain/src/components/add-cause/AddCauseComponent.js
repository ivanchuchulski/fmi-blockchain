import React, { Component } from "react";
import causeService from "../../services/cause.service";
import { Link } from "react-router-dom";
import "./addCause.css";

import { createBrowserHistory } from "history";

const history = createBrowserHistory();

class AddCauseComponent extends Component {
  constructor(props) {
    super(props);

    this.state = {
      cause: {
        title: "",
        description: "",
        creator: "",
        beneficiary: "",
        goal: "",
        currentAmount: "",
        deadlineTimestamp: "",
      },
    };

    this.handleChange = this.handleChange.bind(this);
    this.addCause = this.addCause.bind(this);
  }

  handleChange(event) {
    const { name, value } = event.target;
    const { cause } = this.state;
    this.setState({
      cause: {
        ...cause,
        [name]: value,
      },
    });
  }

  addCause() {
    const { cause } = this.state;
    if (
      cause.title &&
      cause.description &&
      cause.creator &&
      cause.beneficiary &&
      cause.goal &&
      cause.currentAmount &&
      cause.deadlineTimestamp
    ) {
      causeService.addCause(cause);
      history.push("/view-causes");
    }
  }

  render() {
    const { cause } = this.state;
    return (
      <div className="page-wrapper bg p-t-180 p-b-100 font-robo">
        <div className="wrapper wrapper--w960">
          <div>
            <div id="form-div">
              <h2 id="title">Add Cause</h2>
              <form id="causeForm">
                <div id="input-field-div">
                  <input
                    className="input"
                    type="text"
                    name="title"
                    placeholder="Title"
                    value={cause.title}
                    onChange={this.handleChange}
                  />
                </div>
                <div>
                  <input
                    className="input"
                    type="text"
                    name="description"
                    placeholder="Description"
                    value={cause.description}
                    onChange={this.handleChange}
                  />
                </div>
                <div>
                  <input
                    className="input"
                    type="text"
                    name="goal"
                    placeholder="Goal"
                    value={cause.goal}
                    onChange={this.handleChange}
                  />
                </div>
                <div>
                  <input
                    className="input"
                    type="text"
                    name="creator"
                    placeholder="Creator"
                    value={cause.creator}
                    onChange={this.handleChange}
                  />
                </div>
                <div>
                  <input
                    className="input"
                    type="text"
                    name="currentAmount"
                    placeholder="Current amount"
                    value={cause.currentAmount}
                    onChange={this.handleChange}
                  />
                </div>
                <div>
                  <input
                    className="input"
                    type="text"
                    placeholder="Beneficiary"
                    name="beneficiary"
                    value={cause.beneficiary}
                    onChange={this.handleChange}
                  />
                </div>
                <div>
                  <input
                    className="input"
                    type="text"
                    name="deadline"
                    placeholder="Deadline"
                    value={cause.deadlineTimestamp}
                    onChange={this.handleChange}
                  />
                </div>
                <div className="form-group">
                  <div className="p-t-30">
                    <button
                      className="btn btn--radius btn--green"
                      type="submit"
                      onClick={this.addCause}
                    >
                      Add cause
                    </button>

                    <Link to="/view-causes" className="btn btn-primary">
                      Cancel
                    </Link>
                  </div>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    );
  }
}
export default AddCauseComponent;
