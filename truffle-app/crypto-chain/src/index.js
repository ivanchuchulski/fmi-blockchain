import { render } from "react-dom";
import { BrowserRouter as Router } from "react-router-dom";
import "bootstrap/dist/css/bootstrap.min.css";
import Routes from "./routes/Routes";

render(
  <Router>
    <Routes />
  </Router>,
  document.getElementById("root")
);
