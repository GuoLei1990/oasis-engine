import { ShaderPass } from "./ShaderPass";
import { ShaderString } from "./ShaderString";

/**
 * Sub shader.
 */
export class SubShader {
  /** Disable batch. */
  disableBatch: boolean = false;

  private _replacementTagsMap: Record<number, ShaderString>;
  private _passes: ShaderPass[] = [];

  /**
   * Sub shader passes.
   */
  get passes(): ReadonlyArray<ShaderPass> {
    return this._passes;
  }

  /**
   * Create a sub shader.
   * @param name - Name of the sub shader
   * @param passes - Sub shader passes
   */
  constructor(public readonly name: string, passes: ShaderPass[]) {
    const passCount = passes.length;
    if (passCount < 1) {
      throw " count must large than 0.";
    }
    for (let i = 0; i < passCount; i++) {
      this._passes.push(passes[i]);
    }
  }

  /**
   * Add a replacement tag.
   * @param key - Key of the tag
   * @param value - Value of the tag
   */
  addReplacementTag(key: ShaderString, value: ShaderString): void {
    const tags = this._replacementTagsMap;
    if (tags[key._uniqueId]) {
      throw `Tag named "${key}" already exists.`;
    }

    tags[key._uniqueId] = value;
  }

  /**
   * Get a replacement tag.
   * @param key - Key of the tag
   * @returns Value of the tag
   */
  getReplacementTag(key: ShaderString): ShaderString {
    return this._replacementTagsMap[key._uniqueId];
  }
}