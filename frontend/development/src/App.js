import { BrowserRouter, Route, Routes } from "react-router-dom";
import Visualization from "./components/Visualization";
import VisualizationTest from "./components/VisualizationTest";
import "./App.css";

function App() {
  return (
    <div className="App w-screen">
      <BrowserRouter>
        <Routes>
          <Route path="/test" element={<Visualization />} />
          <Route path="/" element={<VisualizationTest />} />
        </Routes>
      </BrowserRouter>
    </div>
  );
}

export default App;
