import React, { Component } from "react";
import { Switch, Redirect } from "react-router-dom";
import Route from "./Route";
import AppNavbar from "../components/navbar/AppNavbar";
import ViewCausesComponent from "../components/view-causes/ViewCausesComponent";
import CauseComponent from "../components/cause/Cause";
import AddCauseComponent from "../components/add-cause/AddCauseComponent";
// import BalanceComponent from "./components/balance/BalanceComponent";

const AppRoute = ({ exact, path, component: Component, isPrivate }) => (
  <Route
    exact={exact}
    path={path}
    isPrivate={isPrivate}
    render={(props) => (
      <div>
        <AppNavbar></AppNavbar>
        <Component {...props} />
      </div>
    )}
  />
);

class Routes extends Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div>
        <Switch>
          <Redirect exact from="/" to="/view-causes" />
          <AppRoute path="/view-causes" component={ViewCausesComponent} />
          <AppRoute path="/view-cause/*" component={CauseComponent} />
          <AppRoute path="/add-cause" component={AddCauseComponent} />
          {/* <AppRoute path="/balance" component={BalanceComponent} /> */}
        </Switch>
      </div>
    );
  }
}

export default Routes;
