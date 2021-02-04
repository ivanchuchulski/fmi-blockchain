import React from "react";
import { Route } from "react-router-dom";

export default function RouteWrapper({
  component: Component,
  isPrivate,
  ...rest
}) {
  return <Route {...rest} component={Component} />;
}

RouteWrapper.defaultProps = {
  isPrivate: false,
};
